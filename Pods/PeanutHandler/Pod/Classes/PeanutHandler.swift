//
//  PeanutHandler.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 24/11/2015.
//
//

import Foundation
import CoreBluetooth
import Alamofire

let UserDescriptionCBUUID = CBUUID(string: "2901")

enum ConnectionMode {
    case NORMAL, DISCOVERY
}

/**
 Class responsible for handling communication with a specific Peanut once it is discovered.
 The typical initialization process a Peanut goes through before it is ready is:
    - Connect
    - Discover services
    - Get mac address if not already known
    - Set current timestamp
    - Get current profile
    - Start getting notifications
*/
public class PeanutHandler: NSObject {
    private static var logTag = "PeanutHandler"
    weak public var delegate: PeanutHandlerDelegate?
    
    public var peanut: Peanut
    var connectionMode: ConnectionMode = .NORMAL
    var needsSettingTime = true
    
    // MARK: Rate control & deduplication
    private var rateController = PeanutRateController(maxRate: 1.0)
    private var duplicateDetector = PeanutDuplicateDetector(bufferSize: 256)
    
    // MARK: Properties backed by Peanut object
    internal(set) public var address: MacAddress? {
        didSet {
            peanut.managedObjectContext?.performBlock {
                [unowned self] in
                self.peanut.address = NSNumber(double: self.address!.value)
                try! self.peanut.managedObjectContext?.save()
            }
        }
    }
    
    internal(set) public var profile: String? {
        didSet {
            peanut.managedObjectContext?.performBlock {
                [unowned self] in
                self.peanut.profile = self.profile
                try! self.peanut.managedObjectContext?.save()
            }
        }
    }
    
    public var rssi: Double?
    
    // MARK: Other properties
    public var peanutPeripheral: CBPeripheral
    
    private var peanutManager: PeanutManager {
        return PeanutManager.sharedInstance()
    }
    
    init(peanutPeripheral: CBPeripheral) {
        self.peanut = Peanut.peanutForPeripheral(peanutPeripheral)!
        self.peanutPeripheral = peanutPeripheral
        super.init()
        self.peanutPeripheral.delegate = self
        
        address = MacAddress(value: peanut.address!.doubleValue)
//        profile = peanut.profile
    }
    
    init(peanut: Peanut, peanutPeripheral: CBPeripheral) {
        self.peanut = peanut
        self.peanutPeripheral = peanutPeripheral
        super.init()
        self.peanutPeripheral.delegate = self
        
        address = MacAddress(value: peanut.address!.doubleValue)
//        profile = peanut.profile
    }
    
    deinit {
        peanutLog.warning("Deinit: \(address?.stringValue ?? "Unknown")")
        writeCallbacks = [:]
    }
    
    // MARK: Properties
    // Whether this Peanut has been seen before (i.e., we know its ID)
    public var isKnown: Bool {
        return (peanut.address?.doubleValue ?? 0) != 0
    }
    
    // MARK: Peanut handling methods
    func startHandlingPeanut() {
        // Make sure main service was discovered
        guard let mainService = peanutPeripheral.mainService
            else {
            return peanutPeripheral.discoverServices([MAIN_SERVICE_CBUUID])
        }
        
        // Make sure characteristics were discovered
        guard peanutPeripheral.notifyCharacteristic != nil && peanutPeripheral.commandCharacteristic != nil
            else {
                return peanutPeripheral.discoverCharacteristics(
                    [NOTIFY_CHARACTERISTIC_CBUUID, WRITE_CHARACTERISTIC_CBUUID],
                    forService: mainService)
        }
        
        initPeanutSession(mainService)
    }
    
    /**
     *   Initiate session with peanut by reading its address and setting its time:
     *      - Get Mac address if not known
     *      - Get current profile
     *      - Set time
     *   If the Connection mode is DISCOVERY, disconnect the Peanut instead of setting the time
     *
     */
    func initPeanutSession(mainService: CBService) {
        peanutLog.debug("Init peanut session, state: \(peanut.state), peripheral state: \(peanutPeripheral.state.rawValue)")
        // A peanutHandler is responsible for only one peanut
        if let mainCharacteristic = peanutPeripheral.commandCharacteristic {
            
            // Peanut is reconnecting, we assume there is no need to reset the time and read the profile
            guard peanut.state != .RECONNECTING
                else {
                    peanutPeripheral.setNotifyValue(true, forCharacteristic: peanutPeripheral.notifyCharacteristic!)
                    peanut.state = .READY
                    return notifyObserversPeanutReady(true)
            }
            
            let timeData = PeanutTime(commandId: .SetTime).getData()
            let profileData = PeanutCommand(commandId: .GetProfileHash).getData()
            // LIFO queue of commands to send to the peanut
            var commands = [profileData, timeData]
            if (address?.value ?? 0 == 0) {
                let addressData = PeanutCommand(commandId: .GetBleAddress).getData()
                commands.append(addressData)
            }
            
            peanutLog.verbose("Prepared \(commands.count) commands")
            
            // TODO: Does this pose threading issues?
            var cmd = {(charact: CBCharacteristic) in return}
            cmd = {(charact: CBCharacteristic) in
                peanutLog.verbose("Sending command, total: \(commands.count)")
                self.peanutPeripheral.readValueForCharacteristic(charact)
                if let command = commands.popLast() {
                    self.writeValue(command, forCharacteristic: charact, withCallback: cmd)
                } else {
                    if self.connectionMode == .DISCOVERY {
                        // Done discovering peanut, can now disconnect
                        debug("Done discovering peanut \(self), disconnecting", logLevel: .Info, tag: PeanutHandler.logTag)
                        self.peanutManager.notifyObserversPeanutDiscovered(self)
                        return self.peanutManager.disconnectPeanut(self)
                    }
                    
                    if let characteristic: CBCharacteristic = (
                        mainService.characteristics!.filter {
                            return $0.UUID == NOTIFY_CHARACTERISTIC_CBUUID
                        }).first as CBCharacteristic! {
                            self.peanutPeripheral.setNotifyValue(
                                true, forCharacteristic: characteristic)
                            
                            // Notify observers peanut is connected
                            self.peanut.state = .READY
                            
                            self.notifyObserversPeanutReady(false)
                    }
                }
            }
            cmd(mainCharacteristic)
        }
    }
    
    /**
     Handle BLE disconnection. Set Peanut state and try reconnecting if not normal disconnection.
     
     - returns: True if the disconnection is normal and the peanut should not reconnect
     */
    func handleDisconnect() -> Bool {
        peanutLog.debug("Handle disconnect, state: \(peanut.state)")
        switch peanut.state {
        case .READY:
            // Reconnect and advertise "soft disconnect"
            peanut.state = .RECONNECTING
            peanutManager.notifyObserversPeanutSoftDisconnect(self)
            
            defer {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(softDisconnectionTimeout * Double(NSEC_PER_SEC))),
                    //                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    dispatch_get_main_queue()) {
                        [unowned self] in
                        self.checkReconnection()
                }
            }
        case .DISCONNECTING:
            peanut.state = .DISCONNECTED
            peanutManager.notifyObserversPeanutDisconnected(self)
            return true
        case .RECONNECTING:
            peanutLog.warning("Invalid state on disconnect")
        case _:
            peanutLog.warning("Peanut \(self) not ready or disconnecting: \(peanut.state), skip notification")
        }
        peanutManager.connectPeanut(self)
        
        return false
    }
    
    @objc func checkReconnection() {
        peanutLog.info("\(self) checking reconnection status, peripheral state: \(peanutPeripheral.state.rawValue)")
        // TODO: Accessing peanut.state might not be thread safe
        if peanut.state == .RECONNECTING {  // Still hasn't reconnected, notify
            peanut.state = .DISCONNECTED
            peanutManager.notifyObserversPeanutDisconnected(self)
        }
    }
    
    private var writeCallbacks: [String:(CBCharacteristic) -> Void] = [:]
    
    private func callbackKey(forCharacteristic characteristic: CBCharacteristic) -> String {
            return
        "\(peanutPeripheral.identifier.UUIDString):\(characteristic.UUID.UUIDString)"
    }
    
    func writeValue(value: NSData, forCharacteristic characteristic: CBCharacteristic,
        withCallback callback: (CBCharacteristic) -> Void) {
            peanutPeripheral.writeValue(value, forCharacteristic: characteristic,
                type: .WithResponse)
            writeCallbacks[callbackKey(forCharacteristic: characteristic)] = callback
    }
    
    private func acknowledgeData(peanutData: PeanutData) {
        let ackCommand = PeanutCommand(commandId: .NotifyAck, extraData: [peanutData.counter!])
        peanutLog.verbose("Data array: \(peanutData.dataArray)")
        peanutLog.debug("Acknowledge data with timestamp: \(peanutData.getTimestamp()), counter: \(peanutData.counter!)")
        peanutLog.verbose("Sending command: \(ackCommand.getBytes())")
        peanutPeripheral.writeValue(ackCommand.getData(),
            forCharacteristic: peanutPeripheral.notifyCharacteristic!,
            type: .WithoutResponse)
    }
}

// MARK: - Hashable
extension PeanutHandler {
    override public var hashValue: Int {
        return peanutPeripheral.hashValue
    }
    
    override public var hash: Int {
        return peanutPeripheral.hash
    }
}

// MARK: - CBPeripheralDelegate
extension PeanutHandler: CBPeripheralDelegate {
    public func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error == nil {
            if let notifyService = (peripheral.services!.filter {
                return $0.UUID == MAIN_SERVICE_CBUUID
                }).first as CBService! {
                    peripheral.discoverCharacteristics([NOTIFY_CHARACTERISTIC_CBUUID,
                        WRITE_CHARACTERISTIC_CBUUID],
                        forService: notifyService)
            }
        } else {
            peanutLog.warning("Error discovering services: \(error)")
        }
    }
    
    public func peripheral(peripheral: CBPeripheral,
        didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
            peanutLog.verbose("Did discover characteristics")
            if error == nil {
                if service.UUID == MAIN_SERVICE_CBUUID {
                    if let _ = (service.characteristics!.filter {
                        return $0.UUID == WRITE_CHARACTERISTIC_CBUUID }).first as CBCharacteristic! {
                        // TODO: Save pointer to characteristic?
                        peanutLog.verbose("Discovered write characteristic")
                    }
                    
                    if let _ = (service.characteristics!.filter {
                        return $0.UUID == NOTIFY_CHARACTERISTIC_CBUUID
                        }).first as CBCharacteristic! {
                            peanutLog.verbose("Discovered notify characteristic")
                    }
                    
                    // TODO: Handle peanut state
//                    initPeanut(peripheral, service: service)
                    initPeanutSession(service)
                    
                    for charac in service.characteristics! {
                        peripheral.discoverDescriptorsForCharacteristic(charac)
                    }
                }
            } else {
                peanutLog.warning("Error discovering characteristics: \(error)")
            }
    }
    
    public func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        peanutLog.verbose("Peripheral \(peripheral) did read rssi: \(RSSI)")
        delegate?.peanutHandler?(self, didReadRSSI: RSSI.doubleValue)
        self.rssi = RSSI.doubleValue
//        peanut.managedObjectContext!.performBlock {
//            [unowned self] in
//            self.peanut.rssi = RSSI
//            try! self.peanut.managedObjectContext?.save()
//        }
    }
    
    public func peripheral(peripheral: CBPeripheral,
        didWriteValueForCharacteristic characteristic: CBCharacteristic,
        error: NSError?) {
            peanutLog.verbose("\(peripheral) did write value: \(characteristic), error: \(error)")
            let key = callbackKey(forCharacteristic: characteristic)
            if let callback = writeCallbacks[key] {
                writeCallbacks.removeValueForKey(key)
                callback(characteristic)
            }
    }
    
    // Handle data
    public func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        guard error == nil
            else {
                peanutLog.warning("Error updating value for characteristic: \(error)")
                return
        }
        
        guard characteristic.value!.length > 0
            else {
                debug("Peanut \(peanut.macAddressString ?? "Unknown") read empty value", logLevel: .Info, tag: PeanutHandler.logTag)
                return
        }
        
        let dataParser = DataParser()
        dataParser.setData(characteristic.value!)
        if let rssi = rssi {
            dataParser.setRSSI(rssi)
        }
        if let deviceAddress = address?.stringValue {
            dataParser.setMacAddress(deviceAddress)
        }
        if let profile = profile {
            dataParser.setProfile(profile)
        }
        let peanutData = dataParser.getParsed()
        peanutLog.verbose("Read data of type: \(peanutData.feedType)")
        
        // Needs to reset time if drift is too big (also catch time set to jan 1st 1970)
        needsSettingTime = peanutData.timestamp.timeIntervalSinceNow < -120
        
        if characteristic.UUID == NOTIFY_CHARACTERISTIC_CBUUID {
            acknowledgeData(peanutData)
        }
        
        if !rateController.checkRateControl(peanutData.serverTimestamp) {
            peanutLog.warning("Received packet too fast")
        }
        
        guard peanutData.feedId != .BleAddress
            else {
                let bleData = peanutData as! BleAddress
                self.address = bleData.macAddress!
                return
        }
        
        if peanutData.feedId == .System {
            let sysData = peanutData as! System
            if let profileId = sysData.getProfileId() {
                if let profile = PeanutProfileType.fromId(profileId) {
                    let profileName = profile.value.name
                    peanutLog.verbose("Got profile \(profileName)")
                    self.profile = profileName
                } else {
                    peanutLog.warning("Unknown profile id: \(profileId)")
                }
            }
        }
        
        // TODO: This is ok while packets are received frequently enough
        // FIXME: Should put packet in buffer and send as soon as we receive the RSSI
        peripheral.readRSSI()
        
        if duplicateDetector.dataIsDuplicate(peanutData) {
            peanutLog.info("Packet was a duplicate")
            peanutManager.notifyObservers(
                withNotificationType: PeanutManagerReceivedDuplicatePacketNotification,
                peanutHandler: self, peanutData: peanutData)
        } else {
            peanutManager.notifyObserversCharacteristicUpdated(self,
                peanutData: peanutData)
            delegate?.peanutHandler?(self, didReceiveData: peanutData)
        }
    }
}

// MARK: - Public API
extension PeanutHandler {
    public func readRSSI() {
        peanutPeripheral.readRSSI()
    }
    
    /**
     Send a system command to the Peanut
     - returns: true iff the command was sent successfully
     */
    public func sendCommand(command: PeanutCommandType) -> Bool {
        // TODO: Throw an exception if not connected?
        if let commandCharacteristic = peanutPeripheral.commandCharacteristic {
            peanutPeripheral.writeValue(command.getData(),
                forCharacteristic: commandCharacteristic,
                type: .WithResponse)
            return true
        }
        
        return false
    }
    
     /**
     Ask the Peanut to set itself in the defined profile
     
     - parameter profile: the profile to set
     */
    public func setProfile(profile: PeanutProfileType) {
        let configCommand = PeanutConfig(commandId: .SetProfile, extraData: profile.value.value.csvToBytes())
        sendCommand(configCommand)
    }
    
     /**
     Asks the Peanut to send a value determind by the type of the command.
     The result of the command is sent through the PeanutServiceDidReceiveData notification.
     Example use:
     ```swift
     let batteryCommand = PeanutCommand(commandId: .GetBattery)
     peanutService.sendReadCommand(batteryCommand, toPeanut: peanut)
     ```
     
     - parameter command: a read command
     
     - returns: true iff the command was sent
     */
    public func sendReadCommand(command: PeanutCommandType) -> Bool {
        // TODO: Throw an exception if not connected?
        if let commandCharacteristic = peanutPeripheral.commandCharacteristic {
            writeValue(command.getData(),
                forCharacteristic: commandCharacteristic,
                withCallback: {
                    [unowned self] characteristic in
                    self.peanutPeripheral.readValueForCharacteristic(commandCharacteristic)
            })
            return true
        }
        return false
    }
    
    override public var description: String {
        return "PeanutHandler<\(address?.stringValue ?? "Unknown address")>"
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if let otherPeanut = object as? PeanutHandler {
            return otherPeanut.peanutPeripheral == peanutPeripheral
        }
        return false
    }
}

// MARK: - Observer pattern
extension PeanutHandler {
    func notifyObserversPeanutReady(isReconnect: Bool = false) {
        if isReconnect {
            peanutManager.delegateProxy.peanutManagerDidReconnectPeanut(peanutManager, peanutHandler: self)
        } else {
            peanutManager.delegateProxy.peanutManagerDidConnectPeanut(peanutManager, peanutHandler: self)
        }
    }
}

public func ==(lhs: PeanutHandler, rhs: PeanutHandler) -> Bool  {
    return lhs.peanutPeripheral == rhs.peanutPeripheral
}


@objc public protocol PeanutHandlerDelegate {
    optional func peanutHandler(peanutHandler: PeanutHandler, didReceiveData data: PeanutData)
    optional func peanutHandler(peanutHandler: PeanutHandler, didReadRSSI rssi: Double)
}
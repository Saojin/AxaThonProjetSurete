//
//  PeanutManager.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 12/02/16.
//
//

import CoreBluetooth
import UIKit
import CoreData
import CoreLocation



// MARK: - PeanutManager
public class PeanutManager: NSObject {
    // MARK: Constants
    private static let logTag = "PeanutManager"
    private let scannedServices = [mainServiceCBUUID]
    public let peanutBeaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: proximityUUIDString)!,
        identifier: peanutBeaconIdentifier)
    
    // MARK: Properties
    private let locationManager = CLLocationManager()
    private var devices: Set<CBPeripheral> = Set<CBPeripheral>()
    /**
     Contains the PeanutHandler objects that correspond to Peanuts either connected or being connected
    */
    private var connectedPeanuts: Set<PeanutHandler> = Set<PeanutHandler>()
    private var centralManager: CBCentralManager?
    private var notificationObservers: NSMutableArray = []
//    var disconnecting: Bool = false
    
    public var state: CBCentralManagerState {
        get {
            return centralManager?.state ?? .PoweredOff
        }
    }
    
    // MARK: Delegate
    internal var delegateProxy: PeanutManagerDelegateProxy = PeanutManagerDelegateProxy()
    public var delegate: PeanutManagerDelegate? {
        set {
            delegateProxy.delegate = newValue
        }
        get {
            return delegateProxy.delegate
        }
    }
    
    // MARK: Scanning
    private var _scanning = false
    public var isScanning: Bool {
        get {
            return _scanning
        }
    }
    public func startScanning(allowDuplicates: Bool?) {
        peanutLog.info("Start scanning")
        
        if let allowDuplicates = allowDuplicates where allowDuplicates {
            centralManager?.scanForPeripheralsWithServices(scannedServices, options: [CBCentralManagerScanOptionAllowDuplicatesKey: allowDuplicates])
        } else {
            centralManager?.scanForPeripheralsWithServices(scannedServices, options: nil)
        }
        
        _scanning = true
        
        delegateProxy.peanutManagerDidStartScanning(self)
        
        if #available(iOS 9.0, *) {
            peanutLog.debug("PeanutManager is scanning: \(centralManager!.isScanning)")
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func stopScanning() {
        peanutLog.info("Stop scanning")
        
        centralManager?.stopScan()
        _scanning = false
        delegateProxy.peanutManagerDidStopScanning(self)
        
        if #available(iOS 9.0, *) {
            peanutLog.debug("PeanutManager is scanning: \(centralManager?.isScanning)")
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Singleton
    static private var _sharedInstance = PeanutManager()
    static public func sharedInstance() -> PeanutManager {
        return _sharedInstance
    }
    
    // Since this is a singleton, the initializer should only be called by sharedInstance()
    override private init() {
        super.init()
        peanutLog.debug("Init")
        setupLogging()
        // Initialize centralManager with an identifier to be enable state restoration
        let centralQueue = dispatch_queue_create(peanutManagerQueueName, DISPATCH_QUEUE_SERIAL)
        centralManager = CBCentralManager(
            delegate: self, queue: centralQueue,
            options: [CBCentralManagerOptionRestoreIdentifierKey: centralManagerRestorationIdentifier,
                CBCentralManagerOptionShowPowerAlertKey: true])
        
        notificationObservers.addObject(
            NSNotificationCenter.defaultCenter().addObserverForName(
                UIApplicationWillTerminateNotification,
                object: nil, queue: nil) {
                    [unowned self] notification in
                    self.saveContext()
                    self.coreDataStack.saveContext()
            }
        )
        locationManager.delegate = self
        
        peanutLog.verbose("Did initialize, context: \(self.managedObjectContext)")
    }
    
    // Try preventing memory leak
    deinit {
        peanutLog.warning("Deinit \(self)")
        let notificationCenter = NSNotificationCenter.defaultCenter()
        for observer in notificationObservers {
            notificationCenter.removeObserver(observer)
        }
        notificationObservers = []
    }
    
    // MARK: - Core Data
    lazy var coreDataStack = {
        return CoreDataStack()
    }()
    
    // Managed context on private queue outside of main thread
    lazy var managedObjectContext: NSManagedObjectContext = {
        [unowned self] in
        return self.coreDataStack.managedObjectContext
    }()
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        [unowned self] in
//        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
//        context.parentContext = self.coreDataStack.managedObjectContext
//        peanutLog.debug("Context: \(context), in thread: \(NSThread.currentThread())")
//        return context
//    }()
    
    private func saveContext() {
        coreDataStack.saveContext()
//        managedObjectContext.performBlock {
//            [unowned self] in
//            if self.managedObjectContext.hasChanges {
//                do {
//                    try self.managedObjectContext.save()
//                } catch {
//                    debug("Error saving context: \(error)",
//                        logLevel: .Error, tag: PeanutManager.logTag)
//                }
//            }
//        }
    }
    
    // MARK: Peripherals
    /**
     - Retrieve the (connected) peanut handler corresponding to this CBPeripheral object
     */
    private func handlerForPeripheral(peripheral: CBPeripheral) -> PeanutHandler? {
        return connectedPeanuts.filter {
            $0.peanutPeripheral.isEqual(peripheral)
            }.first
    }
    
    private func handleConnectedPeripheral(peripheral: CBPeripheral) {
        if let peanutHandler = handlerForPeripheral(peripheral) {
            peanutHandler.startHandlingPeanut()
        } else {
            let peanutHandler = PeanutHandler(peanutPeripheral: peripheral)
            connectedPeanuts.insert(peanutHandler)
            peanutHandler.startHandlingPeanut()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension PeanutManager: CLLocationManagerDelegate {
    public func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        peanutLog.info("Location manager did enter region")
        delegateProxy.peanutManagerDidEnterPeanutRegion(self)
    }
    
    // No use scanning if we're not close to a Peanut
    public func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        peanutLog.info("Location manager did exit region")
        delegateProxy.peanutManagerDidExitPeanutRegion(self)
    }
}

extension PeanutManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(central: CBCentralManager) {
        peanutLog.info("Did update state: \(central.state.rawValue)")
        if central.state == CBCentralManagerState.PoweredOn {
            peanutLog.info("Central ready, \(devices.count) devices")
            startScanning(false)
            if let peripherals = centralManager?.retrieveConnectedPeripheralsWithServices([MAIN_SERVICE_CBUUID]) {
                peanutLog.info("Retrieved connected peripherals: \(peripherals)")
                for peripheral in peripherals {
                    handleConnectedPeripheral(peripheral)
                }
            } else {
                peanutLog.info("No connected peripheral retrieved")
            }
            
            for peripheral in self.devices {
                if peripheral.state == CBPeripheralState.Connected {
                    handleConnectedPeripheral(peripheral)
                } else {
                    centralManager?.connectPeripheral(peripheral, options: nil)
                }
            }
        } else {
            // TODO: Disconnect and remove peanuts?
            // Bluetooth is powered off
            stopScanning()
        }
        
        delegateProxy.peanutManagerDidUpdateState(self)
    }
    
    public func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        peanutLog.debug("Will restore state \(dict)")
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            for peripheral in peripherals {
                self.devices.insert(peripheral)
                switch peripheral.state {
                case CBPeripheralState.Connected:
                    handleConnectedPeripheral(peripheral)
                case CBPeripheralState.Connecting:
                    break
                default:
                    centralManager?.connectPeripheral(peripheral, options: nil)
                }
            }
        }
    }
    
    func centralManager(central: CBCentralManager!, didRetrieveConnectedPeripherals peripherals: [AnyObject]!) {
        debug("Did retrieve connected peripherals: \(peripherals)", logLevel: .Info, tag: PeanutManager.logTag)
        for peripheral in peripherals {
            if let peripheral = peripheral as? CBPeripheral {
                devices.insert(peripheral)
                handleConnectedPeripheral(peripheral)
            }
        }
    }
    
    public func centralManager(central: CBCentralManager,
        didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String : AnyObject], RSSI: NSNumber) {
            debug("Did discover peripheral: \(peripheral), ad data: \(advertisementData)",
                logLevel: .Info, tag: PeanutManager.logTag)
            
            if let peanut = Peanut.peanutForPeripheral(peripheral) {
                peanut.rssi = RSSI
                let peanutHandler = PeanutHandler(peanut: peanut, peanutPeripheral: peripheral)
                peanutHandler.rssi = RSSI.doubleValue
                delegateProxy.peanutManagerDidDiscoverPeanut(self, peanutHandler: peanutHandler)
            }
    }
    
    public func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peanutLog.debug("centralManagerDidConnectPeripheral: \(peripheral), manager: \(ObjectIdentifier(self).uintValue)")
        handleConnectedPeripheral(peripheral)
    }
    
    public func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        peanutLog.warning("Failed to connect to peripheral: \(peripheral), error: \(error)")
        if let peanutHandler = handlerForPeripheral(peripheral) {
            connectedPeanuts.remove(peanutHandler)
        }
    }
    
    public func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
            peanutLog.info("Disconnected from \(peripheral), manager: \(ObjectIdentifier(self).uintValue), error: \(error)")
            guard let peanutHandler = handlerForPeripheral(peripheral)
                else {
                    return
            }
            peanutLog.debug("\(peanutHandler) disconnected")
            
            if peanutHandler.handleDisconnect() {
                peanutLog.debug("Normal disconnection, removing peanut \(peanutHandler.address) handler: \(peanutHandler.peanut)")
                connectedPeanuts.remove(peanutHandler)
            } else {
                peanutLog.debug("Reconnecting to \(peanutHandler)")
            }
    }
}

// MARK: - Notification helpers
extension PeanutManager {
    func notifyObserversCharacteristicUpdated(peanutHandler: PeanutHandler, peanutData: PeanutData) {
        delegateProxy.peanutManagerDidReceiveData(self, peanutHandler: peanutHandler, data: peanutData)
    }
    
    func notifyObservers(withNotificationType notificationType: String, peanutHandler: PeanutHandler, peanutData: PeanutData?) {
        var userInfo: [String: AnyObject] = [
                PeanutManagerNotificationPeanutKey: peanutHandler
        ]
        if let peanutData = peanutData {
            userInfo[PeanutManagerNotificationPeanutDataKey] = peanutData
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(notificationType, object: self, userInfo: userInfo)
    }
    
    /**
     Notify that a Peanut had a "soft" disconnect (i.e. shorter than disconnection timeout)
     
     - parameter peanutHandler: the Peanut that disconnected
     */
    func notifyObserversPeanutSoftDisconnect(peanutHandler: PeanutHandler) {
        peanutLog.debug("Notifying \(peanutHandler) had SOFT disconnect")
        delegateProxy.peanutManagerDidSoftDisconnectPeanut(self, peanutHandler: peanutHandler)
    }

    func notifyObserversPeanutDisconnected(peanutHandler: PeanutHandler) {
        peanutLog.debug("Notifying \(peanutHandler) had HARD disconnect")
        delegateProxy.peanutManagerDidDisconnectPeanut(self, peanutHandler: peanutHandler)
    }
    
    func notifyObserversPeanutDiscovered(peanutHandler: PeanutHandler) {
        delegateProxy.peanutManagerDidDiscoverPeanut(self, peanutHandler: peanutHandler)
    }
}

// MARK: - Public interface
public extension PeanutManager {
    // MARK: Interacting with Peanuts
    /**
     - returns: a list of Peanuts which are connected to this device and ready to send and receive data
     */
    public func getConnectedPeanuts() -> [PeanutHandler] {
        return connectedPeanuts.filter { $0.peanut.state == PeanutState.READY }.sort {
            $0.peanut.address!.doubleValue < $1.peanut.address!.doubleValue }
    }
    
    /**
     - returns: true iff the command was sent successfully
     */
    public func sendCommand(command: PeanutCommandType, toPeanut peanutHandler: PeanutHandler) -> Bool {
        return peanutHandler.sendCommand(command)
    }
    
    /**
     Asks the Peanut to send a value determind by the type of the command.
     The result of the command is sent through the PeanutServiceDidReceiveData notification.
     Example use:
     ```swift
     let batteryCommand = PeanutConfig(commandId: CONFIG_ID_GET_BATTERY)
     peanutService.sendReadCommand(batteryCommand, toPeanut: peanut)
     ```
     */
    public func sendReadCommand(command: PeanutCommandType, toPeanut peanutHandler: PeanutHandler) -> Bool {
        return peanutHandler.sendCommand(command)
    }
    
    // MARK: Connecting and disconnecting from Peanuts
    /**
    Connect to the given Peanut
    
    - parameter peanutHandler: Peanut to connect to
    
    - returns: true
    */
    public func connectPeanut(peanutHandler: PeanutHandler) -> Bool {
        peanutLog.debug("Connecting peanut: \(peanutHandler)")
        
        if !connectedPeanuts.contains(peanutHandler) {
            connectedPeanuts.insert(peanutHandler)
        }
        
        if [.Connected, .Connecting].contains(peanutHandler.peanutPeripheral.state) {
                peanutLog.verbose("Already connected or connnecting to \(peanutHandler)")
//                peanutLog.verbose("Already connected or connnecting")
        }
        
        centralManager!.connectPeripheral(peanutHandler.peanutPeripheral, options: nil)
        peanutLog.info("Connecting to \(peanutHandler.peanut.macAddressString)")
        return true
    }
    
    /**
     Connect to the Peanut to discover its ID and metadata, then disconnect. Avoid receiving notifications
    */
    public func discoverPeanut(peanutHandler: PeanutHandler) {
        peanutHandler.connectionMode = .DISCOVERY
        centralManager?.connectPeripheral(peanutHandler.peanutPeripheral, options: nil)
    }
    
    public func disconnectPeanut(peanutHandler: PeanutHandler) {
        peanutHandler.peanut.state = .DISCONNECTING
        debug("Disconnecting peanut: \(peanutHandler.peanut)", logLevel: .Info, tag: PeanutManager.logTag)
        centralManager?.cancelPeripheralConnection(peanutHandler.peanutPeripheral)
    }
    
    // MARK: Setting up iBeacon monitoring
    public func requestAuthorizations() {
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    public func setupBeaconMonitoring() {
        locationManager.startMonitoringForRegion(peanutBeaconRegion)
    }
}

// MARK: - PeanutManagerDelegate
@objc public protocol PeanutManagerDelegate {
    /**
     Called when the underlying CBCentralManager's state changes
    */
    optional func peanutManagerDidEnterPeanutRegion(peanutManager: PeanutManager)
    optional func peanutManagerDidExitPeanutRegion(peanutManager: PeanutManager)
    optional func peanutManagerDidUpdateState(peanutManager: PeanutManager)
    optional func peanutManagerDidStartScanning(peanutManager: PeanutManager)
    optional func peanutManagerDidStopScanning(peanutManager: PeanutManager)
    optional func peanutManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler)
    optional func peanutManagerDidConnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler)
    optional func peanutManagerDidReconnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler)
    optional func peanutManagerDidSoftDisconnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler)
    optional func peanutManagerDidDisconnectPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler)
    optional func peanutManagerDidReceiveData(peanutManager: PeanutManager, peanutHandler: PeanutHandler, data: PeanutData)
}

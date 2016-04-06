//
//  CoreDataStack.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 11/12/2015.
//
//

import Foundation
import CoreData

// MARK: - Constants
private let defaultSQLStoreName = "PeanutHandler.sqlite"
private let applicationSupportDirectory = NSFileManager.defaultManager().URLsForDirectory(
    .ApplicationSupportDirectory, inDomains: .UserDomainMask).first!
private let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(
    .DocumentDirectory, inDomains: .UserDomainMask).first!
private let applicationName = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String) ?? "PeanutHandler"

// MARK: - CoreDataStack
class CoreDataStack {
    private let logTag = "CoreDataStack"
    
    // MARK: - Properties
    private var _initialized = false
    private var _storeType: String!
    
    var initialized: Bool {
        return _initialized
    }
    
    init() {
        let dic = NSProcessInfo.processInfo().environment
        if dic["StoreType"] == "InMemory" {
            debugPrint("TEST", dic["StoreType"])
//            print("TEST: \(dic["StoreType"])")
            _storeType = NSInMemoryStoreType
        } else {
            print("NO TEST")
            _storeType = NSSQLiteStoreType
        }
        debug("Store type: \(_storeType)", logLevel: .Info, tag: logTag)
    }
    
    init(storeType: String) {
        _storeType = storeType
        debug("Init with store type: \(_storeType)", logLevel: .Info, tag: logTag)
    }
    
    deinit {
        debug("Deinit", logLevel: .Debug, tag: logTag)
        saveContext()
    }
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = NSBundle(identifier: "org.cocoapods.PeanutHandler")
        let modelURL = bundle!.URLForResource("PeanutHandler", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        return model
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        [unowned self] in
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
        let url = documentsDirectory.URLByAppendingPathComponent(defaultSQLStoreName)
        do {
            try coordinator.addPersistentStoreWithType(self._storeType, configuration: nil,
                URL: url, options: nil)
        } catch {
            // TODO: Handle error
            debug("Error building persistent store coordinator: \(error)",
                logLevel: .Error, tag: self.logTag)
        }
        return coordinator
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        [unowned self] in
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        [unowned self] in
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.parentContext = self.privateManagedObjectContext
        return managedObjectContext
    }()
    
    func saveContext() {
        guard managedObjectContext.hasChanges || privateManagedObjectContext.hasChanges
            else { return }
        
        managedObjectContext.performBlockAndWait {
            [unowned self] in
            do {
                try self.managedObjectContext.save()
                
                self.privateManagedObjectContext.performBlock {
                    [unowned self] in
                    do {
                        try self.privateManagedObjectContext.save()
                    } catch {
                        debug("Error saving private context: \(error)", logLevel: .Warning, tag: self.logTag)
                    }
                }
            } catch {
                debug("Error saving context: \(error)", logLevel: .Warning, tag: self.logTag)
            }
        }
    }
}

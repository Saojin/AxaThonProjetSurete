//
//  PeanutList.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 15/12/2015.
//
//

import Foundation
import CoreData


public class PeanutList: NSManagedObject {
    static let entityName = "PeanutList"

// Insert code here to add functionality to your managed object subclass
    static func peanutListWithId(identifier: String,
        inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> PeanutList? {
        let fetchRequest = NSFetchRequest(entityName: PeanutList.entityName)
        fetchRequest.predicate = NSPredicate(format: "identifier == %@",
            identifier)
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if let peanutList = results.first as? PeanutList {
                return peanutList
            } else {
                let peanutList = NSEntityDescription.insertNewObjectForEntityForName(
                    PeanutList.entityName, inManagedObjectContext: managedObjectContext) as? PeanutList
                peanutList?.identifier = identifier
                return peanutList
            }
        } catch let error as NSError {
            print("Caught error \(error), \(error.userInfo)")
        }
        return nil
    }

}

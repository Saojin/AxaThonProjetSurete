//
//  PeanutList+CoreDataProperties.swift
//  Pods
//
//  Created by Axel Colin de Verdiere on 15/12/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

public extension PeanutList {

    @NSManaged var identifier: String?
    @NSManaged var isWhitelist: Bool
    @NSManaged var peanuts: NSSet?

}

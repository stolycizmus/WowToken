//
//  Raw+CoreDataProperties.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 16..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Raw {

    @NSManaged var buy: NSNumber?
    @NSManaged var min24: NSNumber?
    @NSManaged var max24: NSNumber?
    @NSManaged var updatedOn: NSNumber?
    @NSManaged var update: Update?

}

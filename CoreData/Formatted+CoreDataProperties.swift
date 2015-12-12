//
//  Formatted+CoreDataProperties.swift
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

extension Formatted {

    @NSManaged var buy: String?
    @NSManaged var min24: String?
    @NSManaged var max24: String?
    @NSManaged var timeToSell: String?
    @NSManaged var updatedOn: String?
    @NSManaged var update: Update?

}

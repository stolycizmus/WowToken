//
//  Update+CoreDataProperties.swift
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

extension Update {

    @NSManaged var timestamp: NSNumber?
    @NSManaged var region: Regions?
    @NSManaged var raw: Raw?
    @NSManaged var formatted: Formatted?

}

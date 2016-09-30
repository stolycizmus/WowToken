//
//  DataHandler.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 20..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit
import CoreData

    var urlSessionObject = URLSession()
    var lastUpdated = userDefaults.value(forKey: "lastUpdated") as! Int
    var firstRun = userDefaults.value(forKey: "firstRun") as! Bool
    var userDefaults = AppDelegate.sharedAppDelegate.userDefaults
    var jsonIsNotNil = true
    let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext

    var currentRawPrice = 0

    //MARK: - Data pull
    
    
    func parsingData(_ json: JSON){
        //check whether swiftyJSON can handle the pulled JSON
        if json != nil {
            //handle JSON data
            handleData(json)
        }else {
            // handle error
            jsonIsNotNil = false
        }
    }
    
    func handleData(_ json: JSON){
        let prefferedRegion = userDefaults.value(forKey: "prefferedRegion") as! String
        let updateData = json["update"][prefferedRegion].dictionaryObject!
        let rawData = updateData["raw"] as! [String: AnyObject]
        let formattedData = updateData["formatted"] as! [String: AnyObject]
        //Firts run
        if firstRun {
            let entity = NSEntityDescription.entity(forEntityName: "Regions", in: managedObjectContext)
            let region = Regions(entity: entity!, insertInto: managedObjectContext)
            
            let regionData = ["NA": "North American Realms", "EU": "European Realms", "CN": "Chinese Realms", "TW": "Taiwanese Realms", "KR": "Korean Realms"]
            
            region.shortName = prefferedRegion
            region.fullName = regionData[prefferedRegion]
            
            let update = Update(entity: NSEntityDescription.entity(forEntityName: "Update", in: managedObjectContext)!, insertInto: managedObjectContext)
            update.timestamp = updateData["timestamp"] as? NSNumber
            update.region = region
            
            
            let raw = Raw(entity: NSEntityDescription.entity(forEntityName: "Raw", in: managedObjectContext)!, insertInto: managedObjectContext)
            raw.buy = rawData["buy"] as! NSNumber?
            currentRawPrice = raw.buy as! Int
            raw.min24 = rawData["24min"] as! NSNumber?
            raw.max24 = rawData["24max"] as! NSNumber?
            raw.updatedOn = rawData["updated"] as! NSNumber?
            raw.update = update
            
            
            let formatted = Formatted(entity: NSEntityDescription.entity(forEntityName: "Formatted", in: managedObjectContext)!, insertInto: managedObjectContext)
            formatted.buy = formattedData["buy"] as? String
            formatted.min24 = formattedData["24min"] as? String
            formatted.max24 = formattedData["24max"] as? String
            formatted.timeToSell = formattedData["tomeToSell"] as? String
            formatted.updatedOn = formattedData["updated"] as? String
            formatted.update = update
            
            let historyData = json["history"][prefferedRegion].arrayValue
            for history in historyData {
                let _history = History(entity: NSEntityDescription.entity(forEntityName: "History", in: managedObjectContext)!, insertInto: managedObjectContext)
                _history.gold = history[1].intValue as NSNumber
                _history.time = history[0].intValue as NSNumber
                _history.region = region
            }
        }
        //Not first run
        if !firstRun {
            //update raw section
            let fetchRequestRaw =  NSFetchRequest<Raw>(entityName: "Raw")
            fetchRequestRaw.predicate = NSPredicate(format: "update.region.shortName == %@", prefferedRegion)
            do {
                if let raws = try managedObjectContext.fetch(fetchRequestRaw) as? [Raw]{
                    for raw in raws {
                        raw.buy = rawData["buy"] as! NSNumber
                        currentRawPrice = raw.buy as! Int
                        raw.min24 = rawData["24min"] as! NSNumber
                        raw.max24 = rawData["24max"] as! NSNumber
                        raw.updatedOn = rawData["updated"] as! NSNumber
                    }
                }
            } catch {}
            //update formatted section
            let fetchRequestFormatted = NSFetchRequest<Formatted>(entityName: "Formatted")
            fetchRequestFormatted.predicate = NSPredicate(format: "update.region.shortName == %@", prefferedRegion)
            do {
                if let formatteds = try managedObjectContext.fetch(fetchRequestFormatted) as? [Formatted]{
                    for formatted in formatteds {
                        formatted.buy = formattedData["buy"] as? String
                        formatted.min24 = formattedData["24min"] as? String
                        formatted.max24 = formattedData["24max"] as? String
                        formatted.timeToSell = formattedData["tomeToSell"] as? String
                        formatted.updatedOn = formattedData["updated"] as? String
                    }
                }
            } catch {}
            //update update section
            let fetchRequestUpdate = NSFetchRequest<Update>(entityName: "Update")
            fetchRequestUpdate.predicate = NSPredicate(format: "region.shortName == %@", prefferedRegion)
            do {
                if let updates = try managedObjectContext.fetch(fetchRequestUpdate) as? [Update]{
                    for update in updates {
                        update.timestamp = updateData["timestamp"] as? NSNumber
                    }
                }
            }catch {}
            //update history section
            let fetchRequestRegions = NSFetchRequest<Regions>(entityName: "Regions")
            fetchRequestRegions.predicate = NSPredicate(format: "shortName == %@", prefferedRegion)
            var region: Regions?
            do {
                let result = try managedObjectContext.fetch(fetchRequestRegions)
                try region = result[0]
            } catch {}
            
            let fetchRequestHistory = NSFetchRequest<History>(entityName: "History")
            fetchRequestHistory.predicate = NSPredicate(format: "region.shortName == %@", prefferedRegion)
            fetchRequestHistory.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            fetchRequestHistory.fetchLimit = 1
            do {
                if let latestHistory = try managedObjectContext.fetch(fetchRequestHistory) as? [History]{
                    let jsonHistory = json["history"][prefferedRegion].arrayObject as! [NSArray]
                    for arrays in jsonHistory {
                        if arrays[0] as! NSNumber > latestHistory[0].time! {
                            let entity = NSEntityDescription.entity(forEntityName: "History", in: managedObjectContext)
                            let history = History(entity: entity!, insertInto: managedObjectContext)
                            history.time = arrays[0] as? NSNumber
                            history.gold = arrays[1] as? NSNumber
                            history.region = region
                        }
                    }
                }
            } catch {}
        }
        //set firstrun to false
        if firstRun {
            userDefaults.set(false, forKey: "firstRun")
        }
        userDefaults.setValue(Date(timeIntervalSinceNow: 0).timeIntervalSince1970, forKey: "lastUpdated")
        userDefaults.synchronize()
        //save all change
        AppDelegate.sharedAppDelegate.saveContext()
    }

//
//  DataHandler.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 20..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit
import CoreData

    var urlSession = NSURLSession()
    var lastUpdated = userDefaults.valueForKey("lastUpdated") as! Int
    var firstRun = userDefaults.valueForKey("firstRun") as! Bool
    var userDefaults = AppDelegate.sharedAppDelegate.userDefaults
    var jsonIsNotNil = true
    let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext

    var currentRawPrice = 0

    //MARK: - Data pull
    
    func updateWowTokenData(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //pull the data from the server; url sessions handle the error end the data
        let url = NSURL(string: "https://wowtoken.info/wowtoken.json")
        let downloadTask = urlSession.downloadTaskWithURL(url!)
        downloadTask.resume()
    }
    
    func parsingData(json: JSON){
        //check whether swiftyJSON can handle the pulled JSON
        if json != nil {
            //handle JSON data
            handleData(json)
        }else {
            // handle error
            jsonIsNotNil = false
        }
    }
    
    func handleData(json: JSON){
        let prefferedRegion = userDefaults.valueForKey("prefferedRegion") as! String
        let updateData = json["update"][prefferedRegion].dictionaryObject!
        let rawData = updateData["raw"] as! [String: AnyObject]
        let formattedData = updateData["formatted"] as! [String: AnyObject]
        //Firts run
        if firstRun {
            let entity = NSEntityDescription.entityForName("Regions", inManagedObjectContext: managedObjectContext)
            let region = Regions(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            
            let regionData = ["NA": "North American Realms", "EU": "European Realms", "CN": "Chinese Realms", "TW": "Taiwanese Realms", "KR": "Korean Realms"]
            
            region.shortName = prefferedRegion
            region.fullName = regionData[prefferedRegion]
            
            let update = Update(entity: NSEntityDescription.entityForName("Update", inManagedObjectContext: managedObjectContext)!, insertIntoManagedObjectContext: managedObjectContext)
            update.timestamp = updateData["timestamp"] as? NSNumber
            update.region = region
            
            
            let raw = Raw(entity: NSEntityDescription.entityForName("Raw", inManagedObjectContext: managedObjectContext)!, insertIntoManagedObjectContext: managedObjectContext)
            raw.buy = rawData["buy"] as? Int
            currentRawPrice = raw.buy as! Int
            raw.min24 = rawData["24min"] as? Int
            raw.max24 = rawData["24max"] as? Int
            raw.updatedOn = rawData["updated"] as? Int
            raw.update = update
            
            
            let formatted = Formatted(entity: NSEntityDescription.entityForName("Formatted", inManagedObjectContext: managedObjectContext)!, insertIntoManagedObjectContext: managedObjectContext)
            formatted.buy = formattedData["buy"] as? String
            formatted.min24 = formattedData["24min"] as? String
            formatted.max24 = formattedData["24max"] as? String
            formatted.timeToSell = formattedData["tomeToSell"] as? String
            formatted.updatedOn = formattedData["updated"] as? String
            formatted.update = update
            
            let historyData = json["history"][prefferedRegion].arrayObject!
            for history in historyData {
                let _history = History(entity: NSEntityDescription.entityForName("History", inManagedObjectContext: managedObjectContext)!, insertIntoManagedObjectContext: managedObjectContext)
                _history.gold = history[1] as? NSNumber
                _history.time = history[0] as? NSNumber
                _history.region = region
            }
        }
        //Not first run
        if !firstRun {
            //update raw section
            var fetchRequest = NSFetchRequest(entityName: "Raw")
            fetchRequest.predicate = NSPredicate(format: "update.region.shortName == %@", prefferedRegion)
            do {
                if let raws = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Raw]{
                    for raw in raws {
                        raw.buy = rawData["buy"] as? Int
                        currentRawPrice = raw.buy as! Int
                        raw.min24 = rawData["24min"] as? Int
                        raw.max24 = rawData["24max"] as? Int
                        raw.updatedOn = rawData["updated"] as? Int
                    }
                }
            } catch {}
            //update formatted section
            fetchRequest = NSFetchRequest(entityName: "Formatted")
            fetchRequest.predicate = NSPredicate(format: "update.region.shortName == %@", prefferedRegion)
            do {
                if let formatteds = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Formatted]{
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
            fetchRequest = NSFetchRequest(entityName: "Update")
            fetchRequest.predicate = NSPredicate(format: "region.shortName == %@", prefferedRegion)
            do {
                if let updates = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Update]{
                    for update in updates {
                        update.timestamp = updateData["timestamp"] as? NSNumber
                    }
                }
            }catch {}
            //update history section
            fetchRequest = NSFetchRequest(entityName: "Regions")
            fetchRequest.predicate = NSPredicate(format: "shortName == %@", prefferedRegion)
            var region: Regions?
            do {
                if let result = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Regions]{
                   region = result[0]
                }
            } catch {}
            
            fetchRequest = NSFetchRequest(entityName: "History")
            fetchRequest.predicate = NSPredicate(format: "region.shortName == %@", prefferedRegion)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            fetchRequest.fetchLimit = 1
            do {
                if let latestHistory = try managedObjectContext.executeFetchRequest(fetchRequest) as? [History]{
                    let jsonHistory = json["history"][prefferedRegion].arrayObject as! [NSArray]
                    for arrays in jsonHistory {
                        if arrays[0] as! NSNumber > latestHistory[0].time! {
                            let entity = NSEntityDescription.entityForName("History", inManagedObjectContext: managedObjectContext)
                            let history = History(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
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
            userDefaults.setBool(false, forKey: "firstRun")
        }
        userDefaults.setValue(NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970, forKey: "lastUpdated")
        userDefaults.synchronize()
        //save all change
        AppDelegate.sharedAppDelegate.saveContext()
    }

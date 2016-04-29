//
//  ViewController.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 13..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class MainViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var historyButton: Button?
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var historyContainerView: UIView?
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var realmNameLabel: UILabel!
    @IBOutlet weak var buyPriceLabel: UILabel!
    @IBOutlet weak var max24Label: UILabel!
    @IBOutlet weak var min24Label: UILabel!
    @IBOutlet weak var updatedOnLabel: UILabel!
    @IBOutlet weak var arrowView: ArrowView!
    @IBOutlet weak var changeAmmountLabel: UILabel!
    
    var prefferedRegionChanged = false
    var autoUpdateStateChanged = false
    var navigatedBack = false
    var tryingToUpdateData = false
    var historyController = HistoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.translucent = false
    
        urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        urlSession.configuration.timeoutIntervalForRequest = 15
        if !firstRun {
            setLabels()
        }
        
        if firstRun && (historyButton != nil) {
            historyButton?.enabled = false
            historyButton?.alpha = 0.5
        }
        
        refreshButton.enabled = false
        lastUpdatedLabel?.text = "Updating..."
        updateWowTokenData()
        tryingToUpdateData = true
        
        if historyContainerView != nil {
            historyController = storyboard?.instantiateViewControllerWithIdentifier("History") as! HistoryViewController
            historyContainerView?.addSubview(historyController.view)
            historyController.loadView()
            historyController.view.frame = CGRectMake(0, 0, (self.historyContainerView?.frame.width)!, (self.historyContainerView?.frame.height)!)
            self.addChildViewController(historyController)
        }
        
        switchAutoUpdate(AppDelegate.sharedAppDelegate.userDefaults.valueForKey("autoUpdateIsOn") as! Bool)
    }

    func switchAutoUpdate(turnOn: Bool) {
        if turnOn {
            AppDelegate.sharedAppDelegate.updateTimer = NSTimer.scheduledTimerWithTimeInterval(userDefaults.valueForKey("updateTimer") as! Double, target: self, selector: "updateWowTokenData", userInfo: nil, repeats: true)
            let updateTimeInterval = userDefaults.valueForKey("updateTimer") as! NSTimeInterval
            UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(updateTimeInterval)
        } else {
            AppDelegate.sharedAppDelegate.updateTimer.invalidate()
        }
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        //parse the data
        parsingData(JSON(data: NSData(contentsOfURL: location)!))
        if jsonIsNotNil{
            //set labels' texts
            setLabels()
            if historyButton != nil {
                historyButton?.alpha = 1
                historyButton?.enabled = true
            }
        } else {
            lastUpdatedLabel?.text = "Failed to update data."
            let alertController = UIAlertController(title: "Error", message: "Cant parse data", preferredStyle: UIAlertControllerStyle.Alert)
            presentViewController(alertController, animated: true, completion: nil)
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        tryingToUpdateData = false
        refreshButton.enabled = true
        
        if historyContainerView != nil {
            historyController.fetchGraphData(historyController.intervallumPicker)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
               self.historyContainerView?.alpha = 1.0
            })
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            lastUpdatedLabel?.text = "Failed to update data."
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            tryingToUpdateData = false
            refreshButton.enabled = true
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func queryData(){
        lastUpdatedLabel?.text = "Updating..."
        refreshButton.enabled = false
        updateWowTokenData()
    }

    @IBAction func openWowTokenInfo(sender: AnyObject) {
        let safariView = SFSafariViewController(URL: NSURL(string: "http://wowtoken.info")!)
        presentViewController(safariView, animated: true, completion: nil)
    }
    
    func setLabels(){
        let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.valueForKey("prefferedRegion") as! String
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "Regions")
        fetchRequest.predicate = NSPredicate(format: "shortName == %@", prefferedRegion)
        do {
            if let result = try moc.executeFetchRequest(fetchRequest) as? [Regions] {
                realmNameLabel?.text = result[0].fullName
            }
        } catch {}
        
        fetchRequest = NSFetchRequest(entityName: "Formatted")
        fetchRequest.predicate = NSPredicate(format: "update.region.shortName == %@", prefferedRegion)
        do {
            if let result = try moc.executeFetchRequest(fetchRequest) as? [Formatted]{
                let buyprice = result[0].buy! as String
                let max24gold = result[0].max24! as String
                let min24gold = result[0].min24! as String
                buyPriceLabel.text? = String(buyprice.characters.dropLast())
                max24Label?.text = String(max24gold.characters.dropLast())
                min24Label?.text = String(min24gold.characters.dropLast())
                updatedOnLabel?.text = result[0].updatedOn
            }
        } catch {}
        
        if currentRawPrice != 0{
            fetchRequest = NSFetchRequest(entityName: "History")
            fetchRequest.predicate = NSPredicate(format: "region.shortName == %@", prefferedRegion)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            fetchRequest.fetchLimit = 1
            do {
                if let result = try moc.executeFetchRequest(fetchRequest) as? [History]{
                    let latest = result[0].gold as! Int
                    if latest < currentRawPrice {
                        arrowView.isUp = true
                    } else {
                        arrowView.isUp = false
                    }
                    changeAmmountLabel?.text = String(abs(latest - currentRawPrice))
                    arrowView.setNeedsDisplay()
                }
            } catch {}
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        let lastQueryTime = NSDate(timeIntervalSince1970: userDefaults.valueForKey("lastUpdated") as! Double)
        lastUpdatedLabel?.text = "Last query: \(dateFormatter.stringFromDate(lastQueryTime))"
        
    }

    @IBAction func unwindToMainView(segue: UIStoryboardSegue){
        if  prefferedRegionChanged {
            let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.valueForKey("prefferedRegion") as! String
            let fetchRequest = NSFetchRequest(entityName: "Regions")
            fetchRequest.predicate = NSPredicate(format: "shortName == %@", prefferedRegion)
            do {
                if let result = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Regions]{
                    if result == [] {
                        firstRun = true
                    } else { firstRun = true }
                }
            } catch {}
            
            refreshButton.enabled = false
            lastUpdatedLabel?.text = "Updating..."
            updateWowTokenData()
            tryingToUpdateData = true
        }
        
        if autoUpdateStateChanged {
            switchAutoUpdate(userDefaults.valueForKey("autoUpdateIsOn") as! Bool)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settingsSegue" {
            let navContrl = segue.destinationViewController as! UINavigationController
            let vc = navContrl.topViewController as! SettingsTableViewController
            vc.originalRegion = AppDelegate.sharedAppDelegate.userDefaults.valueForKey("prefferedRegion") as! String
        }
        if segue.identifier == "history" {
            let vc = segue.destinationViewController as! HistoryViewController
            vc.navigated = true
        }
    }
        

}


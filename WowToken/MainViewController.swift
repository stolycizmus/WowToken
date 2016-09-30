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

class MainViewController: UIViewController, URLSessionDownloadDelegate {
    
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

        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isTranslucent = false

        urlSessionObject = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        urlSessionObject.configuration.timeoutIntervalForRequest = 15
        
        if !firstRun {
            setLabels()
        }
        
        if firstRun && (historyButton != nil) {
            historyButton?.isEnabled = false
            historyButton?.alpha = 0.5
        }
        
        refreshButton.isEnabled = false
        lastUpdatedLabel?.text = "Updating..."
        updateWowTokenData()
        tryingToUpdateData = true
        
        if historyContainerView != nil {
            historyController = storyboard?.instantiateViewController(withIdentifier: "History") as! HistoryViewController
            historyContainerView?.addSubview(historyController.view)
            historyController.loadView()
            historyController.view.frame = CGRect(x: 0, y: 0, width: (self.historyContainerView?.frame.width)!, height: (self.historyContainerView?.frame.height)!)
            self.addChildViewController(historyController)
        }
        
        switchAutoUpdate(AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "autoUpdateIsOn") as! Bool)
    }
    
    func updateWowTokenData(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //pull the data from the server; url sessions handle the error end the data
        let url = URL(string: "https://wowtoken.info/wowtoken.json")
        let downloadTask = urlSessionObject.downloadTask(with: url!)
        downloadTask.resume()
    }
    
    func switchAutoUpdate(_ turnOn: Bool) {
        if turnOn {
            AppDelegate.sharedAppDelegate.updateTimer = Timer.scheduledTimer(timeInterval: userDefaults.value(forKey: "updateTimer") as! Double, target: self, selector: #selector(MainViewController.updateWowTokenData), userInfo: nil, repeats: true)
            let updateTimeInterval = userDefaults.value(forKey: "updateTimer") as! TimeInterval
            UIApplication.shared.setMinimumBackgroundFetchInterval(updateTimeInterval)
        } else {
            AppDelegate.sharedAppDelegate.updateTimer.invalidate()
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //parse the data
        parsingData(JSON(data: try! Data(contentsOf: location)))
        if jsonIsNotNil{
            //set labels' texts
            setLabels()
            if historyButton != nil {
                historyButton?.alpha = 1
                historyButton?.isEnabled = true
            }
        } else {
            lastUpdatedLabel?.text = "Failed to update data."
            let alertController = UIAlertController(title: "Error", message: "Cant parse data", preferredStyle: UIAlertControllerStyle.alert)
            present(alertController, animated: true, completion: nil)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        tryingToUpdateData = false
        refreshButton.isEnabled = true
        
        if historyContainerView != nil {
            historyController.fetchGraphData(historyController.intervallumPicker)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
               self.historyContainerView?.alpha = 1.0
            })
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            lastUpdatedLabel?.text = "Failed to update data."
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(okAction)
            tryingToUpdateData = false
            refreshButton.isEnabled = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func queryData(){
        lastUpdatedLabel?.text = "Updating..."
        refreshButton.isEnabled = false
        updateWowTokenData()
    }

    @IBAction func openWowTokenInfo(_ sender: AnyObject) {
        let safariView = SFSafariViewController(url: URL(string: "http://wowtoken.info")!)
        present(safariView, animated: true, completion: nil)
    }
    
    func setLabels(){
        let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "prefferedRegion") as! String
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        
        let fetchRequestRegions: NSFetchRequest<Regions> = NSFetchRequest(entityName: "Regions")
        fetchRequestRegions.predicate = NSPredicate(format: "shortName == %@", prefferedRegion)
        do {
            if let result = try moc.fetch(fetchRequestRegions) as? [Regions] {
                realmNameLabel?.text = result[0].fullName
            }
        } catch {}
        
        let fetchRequestFormatted: NSFetchRequest<Formatted> = NSFetchRequest(entityName: "Formatted")
        fetchRequestFormatted.predicate = NSPredicate(format: "update.region.shortName == %@", prefferedRegion)
        do {
            if let result = try moc.fetch(fetchRequestFormatted) as? [Formatted]{
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
            let fetchRequestHistory: NSFetchRequest<History> = NSFetchRequest(entityName: "History")
            fetchRequestHistory.predicate = NSPredicate(format: "region.shortName == %@", prefferedRegion)
            fetchRequestHistory.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
            fetchRequestHistory.fetchLimit = 10
            do {
                if let result = try moc.fetch(fetchRequestHistory) as? [History]{
                    var i = 0
                    while (currentRawPrice == (result[i].gold as! Int)) && i<10 {
                        i += 1
                    }
                    let latest = result[i].gold as! Int
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let lastQueryTime = Date(timeIntervalSince1970: userDefaults.value(forKey: "lastUpdated") as! Double)
        lastUpdatedLabel?.text = "Last query: \(dateFormatter.string(from: lastQueryTime))"
        
    }

    @IBAction func unwindToMainView(_ segue: UIStoryboardSegue){
        if  prefferedRegionChanged {
            let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "prefferedRegion") as! String
            let fetchRequest: NSFetchRequest<Regions> = NSFetchRequest(entityName: "Regions")
            fetchRequest.predicate = NSPredicate(format: "shortName == %@", prefferedRegion)
            do {
                if let result = try managedObjectContext.fetch(fetchRequest) as? [Regions]{
                    if result == [] {
                        firstRun = true
                    } else { firstRun = true }
                }
            } catch {}
            
            refreshButton.isEnabled = false
            lastUpdatedLabel?.text = "Updating..."
            updateWowTokenData()
            tryingToUpdateData = true
        }
        
        if autoUpdateStateChanged {
            switchAutoUpdate(userDefaults.value(forKey: "autoUpdateIsOn") as! Bool)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            let navContrl = segue.destination as! UINavigationController
            let vc = navContrl.topViewController as! SettingsTableViewController
            vc.originalRegion = AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "prefferedRegion") as! String
        }
        if segue.identifier == "history" {
            let vc = segue.destination as! HistoryViewController
            vc.navigated = true
        }
    }
        

}


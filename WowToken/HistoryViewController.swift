//
//  HistoryViewController.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 28..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    @IBOutlet weak var dailyMinLabel: UILabel?
    @IBOutlet weak var dailyMaxLabel: UILabel?
    @IBOutlet weak var averageLabel: UILabel?
    @IBOutlet weak var intervallumPicker: UISegmentedControl!
    @IBOutlet weak var graphView: GraphView!
    
    @IBOutlet weak var graphTitleLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var middleDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    let intervallums: [Double] = [10800, 43200, 86400, 604800]
    var navigated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigated {
            self.navigationItem.title = "History"
            fetchGraphData(intervallumPicker)
            if averageLabel != nil {
                fetchLabelsData()
            }
        }
    }
    
    @IBAction func fetchGraphData(sender: UISegmentedControl){
        let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.valueForKey("prefferedRegion") as! String
        var graphPoints = [Double]()
        var graphPointsLabelText = [String]()
        
        let bottomTime = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970-intervallums[intervallumPicker.selectedSegmentIndex]
        let dateFormatter = NSDateFormatter()
        switch sender.selectedSegmentIndex {
        case 0:
            dateFormatter.dateFormat = "HH:mm"
            graphTitleLabel.text = "Buyprice in the last 3 hours"
        case 1:
            dateFormatter.dateFormat = "MMMdd. HH:mm"
            graphTitleLabel.text = "Buyprice in the last 12 hours"
        case 2:
            dateFormatter.dateFormat = "MMMdd. HH:mm"
            graphTitleLabel.text = "Buyprice in the past 1 day"
        case 3:
            dateFormatter.dateFormat = "MMMdd."
            graphTitleLabel.text = "Buyprice in the past 1 week"
        default: break
        }
            
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "region.shortName == %@ AND time>=\(Int(bottomTime))" ,prefferedRegion)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        do {
            if let result = try moc.executeFetchRequest(fetchRequest) as? [History] {
                for history in result {
                    graphPoints.append(history.gold as! Double)
                    let timeInterval = history.time as! Double
                    graphPointsLabelText.append(dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: timeInterval)))
                }
            }
        } catch {}
        startDateLabel.text = graphPointsLabelText.first
        endDateLabel.text = graphPointsLabelText.last
        middleDateLabel.text = graphPointsLabelText[graphPointsLabelText.count/2]
        graphView.graphPoints = graphPoints
        let maxValue = round(graphPoints.maxElement()!/100)
        let minValue = round(graphPoints.minElement()!/100)
        let middleValue = (maxValue-minValue)/2 + minValue
        maxLabel.text = (maxValue/10).description + "k"
        minLabel.text = (minValue/10).description + "k"
        middleLabel.text = (middleValue/10).description + "k"
        graphView.setNeedsDisplay()
    }
    
    func fetchLabelsData() {
        let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.valueForKey("prefferedRegion") as! String
        var data = [Int]()
        let bottomTime = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970-86400
        
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "region.shortName == %@ AND time>=\(Int(bottomTime))" ,prefferedRegion)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        do {
            if let result = try moc.executeFetchRequest(fetchRequest) as? [History] {
                for history in result {
                    data.append(history.gold as! Int)
                }
            }
        } catch {}
        
        var average = 0
        for item in data {
            average += item
        }
        average = average/data.count
        
        averageLabel?.text = "Daily average: \(average) gold"
        dailyMaxLabel?.text = "Daily maximum: \(data.maxElement()!) gold"
        dailyMinLabel?.text = "Daily minimum:  \(data.minElement()!) gold"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    
    @IBOutlet weak var noDataLabel: UILabel!
    
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
    
    @IBAction func fetchGraphData(_ sender: UISegmentedControl){
        let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "prefferedRegion") as! String
        var graphPoints = [Double]()
        var graphPointsLabelText = [String]()
        
        let bottomTime = Date(timeIntervalSinceNow: 0).timeIntervalSince1970-intervallums[intervallumPicker.selectedSegmentIndex]
        let dateFormatter = DateFormatter()
        switch sender.selectedSegmentIndex {
        case 0:
            dateFormatter.dateFormat = "HH:mm"
            graphTitleLabel.text = "Buyprice in the last 3 hours"
        case 1:
            dateFormatter.dateFormat = "MMM dd. HH:mm"
            graphTitleLabel.text = "Buyprice in the last 12 hours"
        case 2:
            dateFormatter.dateFormat = "MMM dd. HH:mm"
            graphTitleLabel.text = "Buyprice in the past 1 day"
        case 3:
            dateFormatter.dateFormat = "MMM dd."
            graphTitleLabel.text = "Buyprice in the past 1 week"
        default: break
        }
            
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        let fetchRequestHistory: NSFetchRequest<History> = NSFetchRequest(entityName: "History")
        fetchRequestHistory.predicate = NSPredicate(format: "region.shortName == %@ AND time>=\(Int(bottomTime))" ,prefferedRegion)
        fetchRequestHistory.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        do {
            if let result = try moc.fetch(fetchRequestHistory) as? [History] {
                for history in result {
                    if graphPoints.last != (history.gold as! Double) {
                        graphPoints.append(history.gold as! Double)
                    let timeInterval = history.time as! Double
                    graphPointsLabelText.append(dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval)))
                    }
                }
            }
        } catch {}
        //if no data fetched from core data - eg. the server not provided data back to bottomtime
        if !graphPoints.isEmpty {
            //load graphview with data points
            graphView.nodata = false
            for subview in graphView.subviews {
                    subview.isHidden = false
            }
            //9-member moving average for "1 week" datapoints
            if sender.selectedSegmentIndex  == 3 {
                var avgPoints: [Double] = []
                for index in 4...(graphPoints.count-5) {
                    var newElement = Double(0)
                    for _index in index-4...index+4 {
                        newElement += graphPoints[_index]
                    }
                    newElement = newElement/9
                    avgPoints.append(newElement)
                }
                graphPoints = avgPoints
            }
            noDataLabel.isHidden = true
            startDateLabel.text = graphPointsLabelText.first
            endDateLabel.text = graphPointsLabelText.last
            middleDateLabel.text = graphPointsLabelText[graphPointsLabelText.count/2]
            graphView.graphPoints = graphPoints
            let maxValue = round(graphPoints.max()!/100)
            let minValue = round(graphPoints.min()!/100)
            let middleValue = (maxValue-minValue)/2 + minValue
            maxLabel.text = (maxValue/10).description + "k"
            minLabel.text = (minValue/10).description + "k"
            middleLabel.text = (middleValue/10).description + "k"
            graphView.setNeedsDisplay()
        } else {
            //do this if no data points fetched
            graphView.nodata = true
            for subview in graphView.subviews {
                //if subview.tag = 10 then its the title of the graphview, that shouldn't be hidden
                if subview.tag != 10 {
                    subview.isHidden = true
                }
            }
            noDataLabel.isHidden = false
            graphView.setNeedsDisplay()
        }
    }
    
    func fetchLabelsData() {
        let prefferedRegion = AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "prefferedRegion") as! String
        var data = [Int]()
        let bottomTime = Date(timeIntervalSinceNow: 0).timeIntervalSince1970-86400
        
        let moc = AppDelegate.sharedAppDelegate.managedObjectContext
        let fetchRequestHistory: NSFetchRequest<History> = NSFetchRequest(entityName: "History")
        fetchRequestHistory.predicate = NSPredicate(format: "region.shortName == %@ AND time>=\(Int(bottomTime))" ,prefferedRegion)
        fetchRequestHistory.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        do {
            if let result = try moc.fetch(fetchRequestHistory) as? [History] {
                for history in result {
                    data.append(history.gold as! Int)
                }
            }
        } catch {}
        if !data.isEmpty {
        var average = 0
        for item in data {
            average += item
        }
        average = average/data.count
        
        averageLabel?.text = "Daily average: \(average) gold"
        dailyMaxLabel?.text = "Daily maximum: \(data.max()!) gold"
        dailyMinLabel?.text = "Daily minimum:  \(data.min()!) gold"
        } else {
            averageLabel?.text = ""
            dailyMaxLabel?.text = ""
            dailyMinLabel?.text = ""
        }
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

//
//  SettingsTableViewController.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 28..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var lastSelectedRegion = UITableViewCell()
    let regionNames = ["EU", "NA", "CN", "KR", "TW"]
    let userDefaults = AppDelegate.sharedAppDelegate.userDefaults
    var prefferedRegionChanged = false
    var originalRegion = ""
    var autoUpdateChanged = false
    let updateIntervalRawValues = [300, 600, 1800, 3600, 7200, 21600, 43200, 86400]
    let updateIntervalStringValues = ["5 minutes", "10 minutes", "30 minutes", "1 hour", "2 hours", "6 hours", "12 hours", "24 hours"]
    
    @IBOutlet weak var autoUpdateSwicth: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoUpdateSwicth.isOn = AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "autoUpdateIsOn") as! Bool
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && tableView.cellForRow(at: indexPath) != lastSelectedRegion{
            userDefaults.setValue(regionNames[(indexPath as NSIndexPath).row], forKey: "prefferedRegion")
            if regionNames[(indexPath as NSIndexPath).row] != originalRegion {
                prefferedRegionChanged = true
            } else { prefferedRegionChanged = false }
            
            lastSelectedRegion.accessoryType = UITableViewCellAccessoryType.none
            let cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            lastSelectedRegion = cell
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else if (indexPath as NSIndexPath).section == 0 && tableView.cellForRow(at: indexPath) == lastSelectedRegion {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = regionNames.index(of: userDefaults.value(forKey: "prefferedRegion") as! String)
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == row {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            lastSelectedRegion = cell
        }
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1 {
            let updateInterval = userDefaults.value(forKey: "updateTimer") as! Int
            cell.detailTextLabel?.text = updateIntervalStringValues[updateIntervalRawValues.index(of: updateInterval)!]
            cell.isHidden = !(AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "autoUpdateIsOn") as! Bool)
        }
    }

    @IBAction func autoUpdateChanged(_ sender: UISwitch){
        autoUpdateChanged = true
        AppDelegate.sharedAppDelegate.userDefaults.setValue(sender.isOn, forKey: "autoUpdateIsOn")
        if sender.isOn {
            tableView.cellForRow(at: IndexPath(row: 1, section: 1))?.isHidden = false
        } else { tableView.cellForRow(at: IndexPath(row: 1, section: 1))?.isHidden = true }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MainViewController {
            vc.prefferedRegionChanged = prefferedRegionChanged
            vc.autoUpdateStateChanged = autoUpdateChanged
        }
    }

}

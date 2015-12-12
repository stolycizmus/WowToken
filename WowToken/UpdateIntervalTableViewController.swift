//
//  UpdateIntervalTableViewController.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 28..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

class UpdateIntervalTableViewController: UITableViewController {
    
    var updateInterval = AppDelegate.sharedAppDelegate.userDefaults.valueForKey("updateTimer") as! Int
    let updateIntervalRawValues = [300, 600, 1800, 3600, 7200, 21600, 43200, 86400]
    var lastChechMarked = UITableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Update Interval"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        AppDelegate.sharedAppDelegate.userDefaults.setValue(updateIntervalRawValues[indexPath.row], forKey: "updateTimer")
        let vc = self.navigationController?.viewControllers[0] as! SettingsTableViewController
        vc.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))?.detailTextLabel?.text = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
        if tableView.cellForRowAtIndexPath(indexPath) != lastChechMarked {
            lastChechMarked.accessoryType = UITableViewCellAccessoryType.None
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else { tableView.deselectRowAtIndexPath(indexPath, animated: true) }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == NSIndexPath(forRow: updateIntervalRawValues.indexOf(updateInterval)!, inSection: 0){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            lastChechMarked = cell
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

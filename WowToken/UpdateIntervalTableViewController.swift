//
//  UpdateIntervalTableViewController.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 28..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit

class UpdateIntervalTableViewController: UITableViewController {
    
    var updateInterval = AppDelegate.sharedAppDelegate.userDefaults.value(forKey: "updateTimer") as! Int
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.sharedAppDelegate.userDefaults.setValue(updateIntervalRawValues[(indexPath as NSIndexPath).row], forKey: "updateTimer")
        let vc = self.navigationController?.viewControllers[0] as! SettingsTableViewController
        vc.tableView.cellForRow(at: IndexPath(row: 1, section: 1))?.detailTextLabel?.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        if tableView.cellForRow(at: indexPath) != lastChechMarked {
            lastChechMarked.accessoryType = UITableViewCellAccessoryType.none
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            tableView.deselectRow(at: indexPath, animated: true)
        } else { tableView.deselectRow(at: indexPath, animated: true) }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: updateIntervalRawValues.index(of: updateInterval)!, section: 0){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
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

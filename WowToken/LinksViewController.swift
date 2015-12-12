//
//  LinksViewController.swift
//  WowToken
//
//  Created by Kadasi Mate on 2015. 11. 28..
//  Copyright © 2015. Tairpake Inc. All rights reserved.
//

import UIKit
import SafariServices

class LinksViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Links"
        
    }

    @IBAction func grayIconTapped(sender: AnyObject) {
        let safariView = SFSafariViewController(URL: NSURL(string: "http://www.wowhead.com/item=122270/wow-token")!)
        presentViewController(safariView, animated: true, completion: nil)
    }
    
    @IBAction func colorIconTapped(sender: AnyObject) {
        let safariView = SFSafariViewController(URL: NSURL(string: "http://www.wowhead.com/item=122284/wow-token")!)
        presentViewController(safariView, animated: true, completion: nil)
    }
    
    @IBAction func guideButtonPressed(sender: AnyObject) {
        let safariView = SFSafariViewController(URL: NSURL(string: "http://www.wowhead.com/guides/wow-token")!)
        presentViewController(safariView, animated: true, completion: nil)
    }
    
    @IBAction func officialSiteButtonTapped(sender: AnyObject) {
        let safariView = SFSafariViewController(URL: NSURL(string: "http://battle.net/shop/product/world-of-warcraft-token")!)
        presentViewController(safariView, animated: true, completion: nil)
    }
    
    @IBAction func dataButtonTapped(sender: AnyObject) {
        let safariView = SFSafariViewController(URL: NSURL(string: "http://wowtoken.info")!)
        presentViewController(safariView, animated: true, completion: nil)
    }
    
    @IBAction func licenseButtonTapped(sender: AnyObject) {
        let safariView = SFSafariViewController(URL: NSURL(string: "http://opendatacommons.org/licenses/by/1.0/")!)
        presentViewController(safariView, animated: true, completion: nil)
    }

}

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

    @IBAction func grayIconTapped(_ sender: AnyObject) {
        let safariView = SFSafariViewController(url: URL(string: "http://www.wowhead.com/item=122270/wow-token")!)
        present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func colorIconTapped(_ sender: AnyObject) {
        let safariView = SFSafariViewController(url: URL(string: "http://www.wowhead.com/item=122284/wow-token")!)
        present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func guideButtonPressed(_ sender: AnyObject) {
        let safariView = SFSafariViewController(url: URL(string: "http://www.wowhead.com/guides/wow-token")!)
        present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func officialSiteButtonTapped(_ sender: AnyObject) {
        let safariView = SFSafariViewController(url: URL(string: "http://battle.net/shop/product/world-of-warcraft-token")!)
        present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func dataButtonTapped(_ sender: AnyObject) {
        let safariView = SFSafariViewController(url: URL(string: "http://wowtoken.info")!)
        present(safariView, animated: true, completion: nil)
    }
    
    @IBAction func licenseButtonTapped(_ sender: AnyObject) {
        let safariView = SFSafariViewController(url: URL(string: "http://opendatacommons.org/licenses/by/1.0/")!)
        present(safariView, animated: true, completion: nil)
    }

}

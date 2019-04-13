//
//  RepliesTableViewController.swift
//  DALI Yak
//
//  Created by Sofia Stanescu-Bellu on 4/12/19.
//  Copyright © 2019 You. All rights reserved.
//

import UIKit

class RepliesTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - variables
    var replies: [Reply]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell")
        
        if let cell = cell as? ReplyTableViewCell {
           print("Fetched cell")
        }
        
        return cell!
    }
}

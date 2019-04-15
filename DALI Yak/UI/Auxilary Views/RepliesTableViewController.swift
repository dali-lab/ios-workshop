//
//  RepliesTableViewController.swift
//  DALI Yak
//
//  Created by Sofia Stanescu-Bellu on 4/12/19.
//  Copyright © 2019 You. All rights reserved.
//

import UIKit
import EmitterKit

class RepliesTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - variables
    var replyListener: Listener?
    var replies: [Reply]?
    var post: Post? {
        didSet {
            replyListener?.isListening = false
            replyListener = post?.repliesChangedEvent.on { (newReplies) in
                self.replies = newReplies
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell")
        
        if let cell = cell as? ReplyTableViewCell {
            cell.reply = replies?[indexPath.item]
        }
        
        return cell!
    }
}

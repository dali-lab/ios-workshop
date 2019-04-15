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
    var post: Post!
    var replies: [Reply]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyListener = post.repliesChangedEvent.on { (newReplies) in
            self.replies = newReplies.sorted(by: { (reply1, reply2) -> Bool in
                return reply1.createdAt > reply2.createdAt
            })
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell")
        
        if let cell = cell as? ReplyTableViewCell {
            let reply = replies![indexPath.item]
            
            cell.message.text = reply.message
            cell.createdAt.text = reply.timeSinceText
        }
        
        return cell!
    }
}

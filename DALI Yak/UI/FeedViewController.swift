//
//  FeedViewController.swift
//  DALI Yak
//
//  Created by John Kotz on 4/7/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

class FeedViewController: UITableViewController {
    var posts: [Post]?
    var postListener: Listener?
    
    override func viewDidLoad() {
        postListener = Post.postsChangedEvent.on { (posts) in
            self.posts = posts.sorted(by: { (post1, post2) -> Bool in
                return post1.numVotes > post2.numVotes
            })
            self.tableView.reloadData()
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 154
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Post.startListeningForPosts()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let cell = cell as? FeedViewControllerCell {
            cell.post = posts?[indexPath.row]
        }
        
        return cell!
    }
}

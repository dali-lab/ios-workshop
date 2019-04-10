//
//  FeedViewController.swift
//  DALI Yak
//
//  Created by John Kotz on 4/7/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class FeedViewController: UITableViewController {
    var posts: [Post]?
    var postListener: ListenerRegistration?
    
    override func viewWillAppear(_ animated: Bool) {
        Post.getAll { (posts, error) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        postListener?.remove()
        postListener = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let cell = cell as? FeedViewControllerCell {
            cell.post = nil
        }
        
        return cell!
    }
}

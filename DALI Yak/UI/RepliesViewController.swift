//
//  RepliesViewController.swift
//  DALI Yak
//
//  Created by Sofia Stanescu-Bellu on 4/12/19.
//  Copyright © 2019 You. All rights reserved.
//

import UIKit

class RepliesViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var numVotesLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var upChevron: UIButton!
    @IBOutlet weak var downChevron: UIButton!
    @IBOutlet weak var weeksLabel: UILabel!
    
    // MARK: - variables
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure post labels
        messageLabel.text = post.message
        numVotesLabel.text = String(post.numVotes)
        repliesLabel.text = "\(post?.replies.count ?? 0) replies"
        weeksLabel.text = post.timeSinceText
    }
}

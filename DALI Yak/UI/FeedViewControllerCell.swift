//
//  FeedViewControllerCell.swift
//  DALI Yak
//
//  Created by John Kotz on 4/7/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

class FeedViewControllerCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel! // eg. "Hmmm. If only people started..."
    @IBOutlet weak var numVotesLabel: UILabel! // eg. "357
    @IBOutlet weak var repliesLabel: UILabel! // eg. "31 replies"
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var upChevron: UIButton!
    @IBOutlet weak var downChevron: UIButton!
    
    var listener: Listener?
    
    var post: Post? {
        didSet {
            update()
            listener = post?.repliesChangedEvent.on({ (_) in
                self.update()
            })
        }
    }
    
    deinit {
        listener?.isListening = false
    }
    
    func update() {
        messageLabel.text = post?.message
        repliesLabel.text = "\(post?.replies.count ?? 0) replies"
        numVotesLabel.text = "\(post?.numVotes ?? 0)"
        weeksLabel.text = post?.timeSinceText
    }
    
    @IBAction func voteButtonPressed(_ sender: UIButton) {
        if sender == upChevron {
            post?.numVotes += 1
        } else if sender == downChevron {
            post?.numVotes -= 1
        }
        update()
    }
}

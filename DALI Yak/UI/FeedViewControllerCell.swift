//
//  FeedViewControllerCell.swift
//  DALI Yak
//
//  Created by John Kotz on 4/7/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import UIKit

class FeedViewControllerCell: UITableViewCell {
    @IBOutlet weak var textField: UITextView! // eg. "Hmmm. If only people started..."
    @IBOutlet weak var numVotesLabel: UILabel! // eg. "357
    @IBOutlet weak var repliesLabel: UILabel! // eg. "31 replies"
    @IBOutlet weak var weeksLabel: UILabel!
    
    var post: Post? {
        didSet {
            textField.text = post?.message
            repliesLabel.text = "\(post?.numReplies ?? 0) repies"
            numVotesLabel.text = "\(post?.numVotes ?? 0)"
        }
    }
}

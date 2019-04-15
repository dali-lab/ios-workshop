//
//  ReplyTableViewCell.swift
//  DALI Yak
//
//  Created by Sofia Stanescu-Bellu on 4/12/19.
//  Copyright © 2019 You. All rights reserved.
//

import UIKit
import EmitterKit

class ReplyTableViewCell: UITableViewCell {

    // MARK: - outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    
    var reply: Reply? {
        didSet {
            messageLabel.text = reply?.message
            timeSinceLabel.text = reply?.timeSinceText
        }
    }
}

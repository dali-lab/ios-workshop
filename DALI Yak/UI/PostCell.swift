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

class PostCell: UITableViewCell {
    // MARK: - Outlets
    
    // TODO: Fill this in
    // ...
    
    // MARK: - Data updates
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
    
    // MARK: - UI updates
    
    func update() {
        // TODO: Fill this in
        // ...
    }
    
    // MARK: - IBActions
    // TODO: Listen for presses on up and down arrows
    // ...
}

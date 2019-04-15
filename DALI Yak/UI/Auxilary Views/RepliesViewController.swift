//
//  RepliesViewController.swift
//  DALI Yak
//
//  Created by Sofia Stanescu-Bellu on 4/12/19.
//  Copyright © 2019 You. All rights reserved.
//

import UIKit
import EmitterKit

class RepliesViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var numVotesLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var upChevron: UIButton!
    @IBOutlet weak var downChevron: UIButton!
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyField: UITextField!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var replyViewHeight: NSLayoutConstraint!
    
    // MARK: - variables
    var replyListener: Listener?
    var post: Post!
    var replies: [Reply]?
    var footerView: UIView!
    var replyView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        replies = post.replies
        
        replyListener = post.repliesChangedEvent.on { (newReplies) in
            self.replies = newReplies
            self.repliesLabel.text = "\(self.replies?.count ?? 0) replies"
        }
        
        replyField.delegate = self
        
        // configure post labels
        messageLabel.text = post.message
        numVotesLabel.text = String(post.numVotes)
        repliesLabel.text = "\(post?.replies.count ?? 0) replies"
        weeksLabel.text = post.timeSinceText
        
        // add padding to textfield
        replyField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: replyField.frame.height))
        replyField.leftViewMode = .always
        
        // configure corner radius
        replyField.layer.cornerRadius = 2
        replyField.clipsToBounds = true
        
        send.layer.cornerRadius = 5
        send.clipsToBounds = true
        
        // dismiss keyboard when tapped outside
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        // shift post view up when the keypoard pops up
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - functions
    
    @objc func dismissKeyboard() {
        self.replyViewHeight.constant = 84
        self.bottomSpaceConstraint.constant = 0
        
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.replyViewHeight.constant = 57
                self.bottomSpaceConstraint.constant = keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.replyViewHeight.constant = 84
            self.bottomSpaceConstraint.constant = 0
        }
    }
    
    // MARK: - actions
    
    @IBAction func didTapSend(_ sender: Any) {
        post.newReply(message: replyField.text!) { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Failed to reply",
                                              message: "Something went wrong",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            self.replyField.text = ""
    
            self.dismissKeyboard()
        }
    }
    
    // MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRepliesTableView" {
            let repliesTableView = segue.destination as? RepliesTableViewController
            repliesTableView?.post = post
            repliesTableView?.replies = post.replies.sorted(by: { (reply1, reply2) -> Bool in
                return reply1.createdAt > reply2.createdAt
            })
        }
    }
}

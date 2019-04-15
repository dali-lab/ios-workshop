//
//  WritePostViewController.swift
//  DALI Yak
//
//  Created by John Kotz on 4/9/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import UIKit

class WritePostViewController: UIViewController, UITextViewDelegate {
    private static let placeholder = "eg. Life is too short to eject a USB safely."
    @IBOutlet weak var textView: UITextView!
    
    var activityIndicator: UIActivityIndicatorView!
    var postButton: UIButton!
    
    var processing = false
    
    override func viewDidLoad() {
        textView.text = WritePostViewController.placeholder
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                        to: textView.beginningOfDocument)
        
        postButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        postButton.setTitle("POST", for: .normal)
        postButton.backgroundColor = #colorLiteral(red: 0.3686275482, green: 0.8196078539, blue: 0.7058824897, alpha: 1)
        postButton.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        postButton.addSubview(activityIndicator)
        
        textView.inputAccessoryView = postButton
        setPostButton(enabled: false)
    }
    
    override func viewWillLayoutSubviews() {
        let postTextFrame = postButton.titleLabel!.frame
        let size = activityIndicator.frame.size
        
        activityIndicator.frame = CGRect(origin: CGPoint(x: postTextFrame.minX - size.width - 8,
                                                         y: postButton.frame.height / 2 - size.height / 2),
                                         size: size)
    }
    
    /**
     Remove placeholder when editing
     
     From https://stackoverflow.com/questions/27652227/text-view-placeholder-swift
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if postButton.isEnabled {
                postButtonPressed()
            }
            return false
        }
        
        let currentText = textView.text!
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = WritePostViewController.placeholder
            textView.textColor = UIColor.lightGray
            setPostButton(enabled: false)
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                            to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            setPostButton(enabled: true)
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                            to: textView.beginningOfDocument)
        }
    }
    
    func setPostButton(enabled: Bool) {
        let modifiedEnable = enabled && !processing
        
        postButton.isEnabled = modifiedEnable
        postButton.titleLabel?.alpha = modifiedEnable ? 1.0 : 0.7
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        textView.resignFirstResponder()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func postButtonPressed() {
        setPostButton(enabled: false)
        processing = true
        activityIndicator.startAnimating()
        
        let text = textView.text!
        Post.create(message: text) { (_, error) in
            if error != nil {
                let alert = UIAlertController(title: "Failed to post",
                                              message: "Something went wrong",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.cancelButtonPressed(self.postButton!)
            }
            self.activityIndicator.stopAnimating()
            self.processing = false
        }
    }
}

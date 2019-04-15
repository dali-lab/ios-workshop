//
//  Reply.swift
//  DALI Yak
//
//  Created by John Kotz on 4/8/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import FirebaseFirestore
import EmitterKit

struct Reply {
    /// The contents of this repy
    public let message: String
    /// The date when this reply was created
    public let createdAt: Date
    /// The identifier of this reply
    public let id: String
    
    internal init?(snapshot: DocumentSnapshot) {
        guard
            let data = snapshot.data(),
            let message = data["message"] as? String,
            let createdAt = data["createdAt"] as? Timestamp else {
                return nil
        }
        
        self.message = message
        self.createdAt = createdAt.dateValue()
        self.id = snapshot.documentID
    }
    
    /// A string simply describing how long it has been since this was posted
    public var timeSinceText: String {
        let timeInterval = Date().timeIntervalSince(createdAt)
        let seconds = Float(timeInterval)
        let minutes = seconds / 60.0
        let hours = minutes / 60.0
        let days = hours / 24.0
        let weeks = days / 7.0
        
        if minutes < 1.0 { // Seconds
            return "\(Int(seconds)) Second\(Int(seconds) != 1 ? "s" : "")"
        } else if hours < 1.0 { // Minutes
            return "\(Int(minutes)) Minute\(Int(minutes) != 1 ? "s" : "")"
        } else if days < 1.0 { // Hours
            return "\(Int(hours)) Hour\(Int(hours) != 1 ? "s" : "")"
        } else if weeks < 1.0 { // Days
            return "\(Int(days)) Day\(Int(days) != 1 ? "s" : "")"
        } else { // Weeks
            return "\(Int(weeks)) Week\(Int(weeks) != 1 ? "s" : "")"
        }
    }
}

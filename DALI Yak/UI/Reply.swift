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
}

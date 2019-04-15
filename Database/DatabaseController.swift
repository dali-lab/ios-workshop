//
//  DatabaseController.swift
//  DALI Yak
//
//  Created by John Kotz on 4/7/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DatabaseController {
    private static var _shared: DatabaseController?
    static var shared: DatabaseController {
        if _shared == nil {
            _shared = DatabaseController()
        }
        return _shared!
    }
    
    let db = Firestore.firestore()
}

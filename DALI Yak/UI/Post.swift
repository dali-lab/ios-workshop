//
//  Post.swift
//  DALI Yak
//
//  Created by John Kotz on 4/7/19.
//  Copyright © 2019 You. All rights reserved.
//

import Foundation
import FirebaseFirestore
import EmitterKit

class Post {
    /// The content of the post
    public let message: String
    /// Time and date this post was created
    public let createdAt: Date
    /// The id of the post
    public let id: String
    /// The number of votes
    public var numVotes: Int {
        didSet {
            ref.updateData(["votes": numVotes])
        }
    }
    
    public private(set) var replies: [Reply] = []
    
    /// Event to listen for changes to the replies
    public let repliesChangedEvent = Event<[Reply]>()
    public static let postsChangedEvent = Event<[Post]>()
    
    public var timeSinceText: String {
        let timeInterval = Date().timeIntervalSince(createdAt)
        let seconds = Float(timeInterval)
        let minutes = seconds / 60.0
        let hours = minutes / 60.0
        let days = hours / 24.0
        let weeks = days / 7.0
        
        if minutes < 1.0 { // Seconds
            return "\(Int(seconds)) Seconds"
        } else if hours < 1.0 { // Minutes
            return "\(Int(minutes)) Minutes"
        } else if days < 1.0 { // Hours
            return "\(Int(hours)) Hours"
        } else if weeks < 1.0 { // Days
            return "\(Int(days)) Days"
        } else { // Weeks
            return "\(Int(weeks)) Weeks"
        }
    }
    
    /**
     Create a new post
     
     - parameter message: String content of the message
     - parameter callback: Function called when the post is created
     */
    public static func create(message: String, callback: @escaping (Post?, Error?) -> Void) {
        var ref: DocumentReference?
        ref = collectionRef.addDocument(data: [
            "message": message,
            "createdAt": Date(),
            "votes": 0
        ]) { error in
            if let error = error {
                callback(nil, error)
            } else if let ref = ref {
                Post.load(from: ref, callback: callback)
            } else {
                callback(nil, nil)
            }
        }
    }
    
    /**
     Get all posts
     
     - parameter callback: Function called when the post is created
     */
    public static func getAll(callback: @escaping ([Post]?, Error?) -> Void) {
        collectionRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                callback(nil, error)
                return
            }
            
            let documents = snapshot.documents
            let posts = documents.compactMap({ (snapshot) -> Post? in
                return Post(snapshot: snapshot)
            })
            callback(posts, nil)
        }
    }
    
    /**
     Keep the replies up to date
     */
    public func startListeningForReplies() {
        if repliesListener != nil {
            return
        }
        
        repliesListener = ref.collection("Replies").addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else {
                return
            }
            
            let replies = snapshot.documents.compactMap({ (snapshot) -> Reply? in
                return Reply(snapshot: snapshot)
            })
            self.replies = replies
            self.repliesChangedEvent.emit(replies)
        }
    }
    
    /**
     Stop keeping the replies up to date
     */
    public func stopListeningForReplies() {
        repliesListener?.remove()
    }
    
    public static func startListeningForPosts() {
        guard postsListener == nil else {
            return
        }
        
        postsListener = collectionRef.addSnapshotListener({ (snapshot, _) in
            guard let snapshot = snapshot else {
                return
            }
            
            let posts = snapshot.documents.compactMap({ (snapshot) -> Post? in
                return Post(snapshot: snapshot)
            })
            postsChangedEvent.emit(posts)
        })
    }
    
    public static func stopListeningForPosts() {
        postsListener?.remove()
    }
    
    // MARK: - Private
    
    private static var postsListener: ListenerRegistration?
    private static var collectionRef: CollectionReference {
        return DatabaseController.shared.db.collection("Posts")
    }
    private let ref: DocumentReference
    private var repliesListener: ListenerRegistration?
    
    private static func load(from ref: DocumentReference, callback: @escaping (Post?, Error?) -> Void) {
        ref.getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {
                callback(nil, error)
                return
            }
            callback(Post(snapshot: snapshot), nil)
        }
    }
    
    private init?(data: [String: Any], id: String, ref: DocumentReference) {
        guard
            let message = data["message"] as? String,
            let numVotes = data["votes"] as? Int,
            let createdAtTimestamp = data["createdAt"] as? Timestamp else {
                return nil
        }
        
        self.ref = ref
        self.message = message
        self.id = id
        self.createdAt = createdAtTimestamp.dateValue()
        self.numVotes = numVotes
        
        startListeningForReplies()
    }
    
    deinit {
        stopListeningForReplies()
    }
    
    private convenience init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else {
            return nil
        }
        self.init(data: data, id: snapshot.documentID, ref: snapshot.reference)
    }
}

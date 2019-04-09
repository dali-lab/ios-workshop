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

struct Post {
    /// The content of the post
    public let message: String
    /// Time and date this post was created
    public let createdAt: Date
    /// The id of the post
    public let id: String
    
    /// Event to listen for changes to the replies
    public let repliesChangedEvent = Event<[Reply]>()
    
    /**
     Create a new post
     
     - parameter message: String content of the message
     - parameter callback: Function called when the post is created
     */
    public static func create(message: String, callback: @escaping (Post?, Error?) -> Void) {
        var ref: DocumentReference?
        ref = collectionRef.addDocument(data: [
            "message": message,
            "createdAt": Date()
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
     Observes all posts
     
     - parameter callback: Function called when new data is available
     - returns: ListenerRegistration (Usage `listener.remove()`)
     */
    public static func observeAll(callback: @escaping ([Post]) -> Void) -> ListenerRegistration {
        return collectionRef.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else {
                return
            }
            
            let posts = snapshot.documents.compactMap({ (snapshot) -> Post? in
                return Post(snapshot: snapshot)
            })
            callback(posts)
        }
    }
    
    /**
     Start observing replies
     */
    public func observeReplies(callback: @escaping ([Reply]) -> Void) -> ListenerRegistration {
        return ref.collection("Replies").addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else {
                return
            }
            
            let replies = snapshot.documents.compactMap({ (snapshot) -> Reply? in
                return Reply(snapshot: snapshot)
            })
            callback(replies)
            self.repliesChangedEvent.emit(replies)
        }
    }
    
    // MARK: - Private
    
    private static var collectionRef: CollectionReference {
        return DatabaseController.shared.db.collection("Posts")
    }
    private let ref: DocumentReference
    private var listener: Listener?
    
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
            let createdAt = data["createdAt"] as? Date else {
                return nil
        }
        
        self.ref = ref
        self.message = message
        self.id = id
        self.createdAt = createdAt
    }
    
    private init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else {
            return nil
        }
        self.init(data: data, id: snapshot.documentID, ref: snapshot.reference)
    }
}

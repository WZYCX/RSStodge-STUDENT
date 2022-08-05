//
//  Firebase.swift
//  Rugby School Stodge
//
//  Created by William Chen on 03/08/2022.
//

import SwiftUI
import Firebase

class FirestoreManager: ObservableObject {
    
    @Published var user: String = ""
    
    init() {
        fetchAllUsers() //remove at a later date
    }

    func fetchAllUsers() { // fetches all documents in users
            let db = Firestore.firestore() // links to firestore

            db.collection("Users").getDocuments() { (querySnapshot, error) in //gets all docs in Users
                            if let error = error {
                                    print("Error getting documents: \(error)")
                            } else {
                                    for document in querySnapshot!.documents {
                                            print("\(document.documentID): \(document.data())") // returns William Chen: ["Password": 1234, "name": William Chen, "UserID": 1234]
                                    }
                            }
            }
    }
}

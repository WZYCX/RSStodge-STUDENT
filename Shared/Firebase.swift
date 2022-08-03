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
    //function used to authenticate a user in firebase db
    public func checkAllUsers(CheckUserID: String , CheckPassword: String) -> Bool {
        let db = Firestore.firestore() // links to firestore
        var valid = false
        db.collection("Users").getDocuments() { (querySnapshot, error) in //gets all docs in Users
                        if let error = error {
                                print("Error getting documents: \(error)")
                        } else {
                                for document in querySnapshot!.documents {
                                    
                                    //sets the current user info into variables
                                    //var data = document.data()
                                    let currentUserID = "\(document.get("UserID")!)"
                                    let currentPassword = "\(document.get("Password")!)" //'any' type but needs to be 'string' for below condition statement
                                    
                                    /*
                                    let data = document.data()
                                    let currentUserID = data["UserID"]! as? String ?? ""
                                    let currentPassword = data["Password"]! as? String ?? ""
                                     //doesnt work
                                     */
                                    print(currentUserID) // debug
                                    print(currentPassword) //debug
    
                                    //checks if Check ID and Password match the current user info from firebase
                                    if currentUserID == CheckUserID && currentPassword == CheckPassword {
                                        print("Username found: \(document.documentID)")
                                        valid = true
                                    }
                                    
                                }
                        }
        }
        print(valid) // code not being run should be moved up
        return valid
    }
}

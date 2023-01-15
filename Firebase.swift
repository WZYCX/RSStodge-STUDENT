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
        //fetchAllUsers() //remove at a later date
        //fetchAllItems() //remove at a later date
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
    
    func fetchAllItems() {
        let db = Firestore.firestore() // links to firestore
        
        db.collection("Items").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            var all = documents.map { Item(id: $0.documentID, name: "\($0["Name"]!)" , desc: "\($0["Description"]!)", cost: "\($0["Sales Price"]!)", category: "\($0["Category"]!)", image: "\($0["Image"]!)", stock: "\($0["Stock"]!)", count: 0) // $0 is first parameter
                
            }
            print("All: \(all)")
        }
                        
                        /// returns:
                        /// [Rugby_School_Stodge_STUDENT.Item(id: "29evVAtyMn4vN6IiaUpD", name: "Harrogate Water (Still)", desc: "Still Water", cost: "0.50", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/water.webp?alt=media&token=294ae8ec-0cbf-4229-a7ac-02baeef46c46", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "OxhJ0womCFUu6O5JPWCc", name: "Walkers Crisps (Cheese and Onion)", desc: "Cheese and Onion Crisps", cost: "0.50", category: "Snacks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Cheese%20and%20Onion.png?alt=media&token=6dc5ad2d-7df4-4e0d-b87d-5306316f1979", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "QYPvJbNELMRoG3tMetTf", name: "Walkers Crisps (Salt and Vinegar)", desc: "Salt and Vinegar Crisps", cost: "0.50", category: "Snacks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Salt%20and%20Vinegar.png?alt=media&token=2e5ad30d-bb69-43aa-acdb-2a26c0a309d6", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "VXoI0oL0HwrLy9ig32Tb", name: "Chicken Burger", desc: "Hot Chicken Burger with Cheese", cost: "1.20", category: "Hot Food", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Chicken%20Burger.png?alt=media&token=e4ac0c95-0f51-4d99-a4f3-44ed300528b4", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "YTKYOGW8AQf7vzq0GNAo", name: "Appletiser", desc: "Sparkling Apple Drink", cost: "1", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Appletiser.png.webp?alt=media&token=464f5f38-7f94-4ff6-ac24-c00b413eaeb3", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "hvF31DzYkwVhyUJ36e85", name: "Walkers Crisps (Ready Salted)", desc: "Ready Salted Crisps", cost: "0.50", category: "Snacks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Ready%20Salted.webp?alt=media&token=194f0fd3-ec11-47c4-9bd4-54a8f0e783e7", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "uxfrLB0kPTkawtuGlC63", name: "Lucozade Sport (Orange)", desc: "Orange Flavoured Lucozade Sport Energy Drink ", cost: "1.00", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Orange%20Lucozade.jpg?alt=media&token=b4b0284e-cb1c-4041-a9f0-6b51552e3896", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "vriubKiOnapl23JmKZFv", name: "Lipton Ice Tea (Peach)", desc: "Peach Ice Tea drink", cost: "1.20", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Peach%20Ice%20Tea.png?alt=media&token=30ee68d5-935e-4e21-8584-84ef9190d219", Count: 0)]
             
    }
}

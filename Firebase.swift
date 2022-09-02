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
        fetchAllItems() //remove at a later date
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
        
        db.collection("Items").getDocuments() { (querySnapshot, error) in //gets all docs in Users
            if let error = error {
                    print("Error getting documents: \(error)")
            } else {
                for item in querySnapshot!.documents {
                    //var current = Item(id: item.documentID, name: item.data()["Name"], desc: item.data()["Description"], cost: item.data()["Sales Price"], category: item.data()["Category"], image: item.data()["Image"], Count: 0) // sets the item from Firebase to Item type object.
                    
                        print("\(item.documentID): \(item.data())")
                        
                        /// returns:
                        /// 29evVAtyMn4vN6IiaUpD: ["Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/water.webp?alt=media&token=294ae8ec-0cbf-4229-a7ac-02baeef46c46, "Description": Still Water, "Cost Price": 0.50, "Category": Drinks, "Sales Price": 1.50, "Name": Harrogate Water (Still)]
                        /// OxhJ0womCFUu6O5JPWCc: ["Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Cheese%20and%20Onion.png?alt=media&token=6dc5ad2d-7df4-4e0d-b87d-5306316f1979, "Description": Cheese and Onion Crisps, "Cost Price": 0.50, "Category": Snacks, "Sales Price": 1.00, "Name": Walkers Crisps (Cheese and Onion)]
                        /// QYPvJbNELMRoG3tMetTf: ["Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Salt%20and%20Vinegar.png?alt=media&token=2e5ad30d-bb69-43aa-acdb-2a26c0a309d6, "Description": Salt and Vinegar Crisps, "Cost Price": 0.50, "Category": Snacks, "Sales Price": 1.00, "Name": Walkers Crisps (Salt and Vinegar)]
                        /// VXoI0oL0HwrLy9ig32Tb: ["Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Chicken%20Burger.png?alt=media&token=e4ac0c95-0f51-4d99-a4f3-44ed300528b4, "Description": Hot Chicken Burger with Cheese, "Cost Price": 1.20, "Category": Hot Food, "Sales Price": 1.90, "Name": Chicken Burger]
                        /// YTKYOGW8AQf7vzq0GNAo: ["Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Appletiser.png.webp?alt=media&token=464f5f38-7f94-4ff6-ac24-c00b413eaeb3, "Description": Sparkling Apple Drink, "Cost Price": 1, "Category": Drinks, "Sales Price": 2, "Name": Appletiser]
                        /// hvF31DzYkwVhyUJ36e85: ["Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Ready%20Salted.webp?alt=media&token=194f0fd3-ec11-47c4-9bd4-54a8f0e783e7, "Description": Ready Salted Crisps, "Cost Price": 0.50, "Category": Snacks, "Sales Price": 1.00, "Name": Walkers Crisps (Ready Salted)]
                        /// uxfrLB0kPTkawtuGlC63: ["Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Orange%20Lucozade.jpg?alt=media&token=b4b0284e-cb1c-4041-a9f0-6b51552e3896, "Description": Orange Flavoured Lucozade Sport Energy Drink , "Cost Price": 1.00, "Category": Drinks, "Sales Price": 1.90, "Name": Lucozade Sport (Orange)]
                        /// vriubKiOnapl23JmKZFv: ["Sales Price": 1.90, "Name": Lipton Ice Tea (Peach), "Category": Drinks, "Cost Price": 1.20, "Description": Peach Ice Tea drink, "Image": https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Peach%20Ice%20Tea.png?alt=media&token=30ee68d5-935e-4e21-8584-84ef9190d219]
                }
            }
        }
    }
}

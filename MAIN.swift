import SwiftUI
import Firebase


@main
struct Stodge: App {
    
    @StateObject var viewRouter = ViewRouter() //MotherView
    @StateObject var firestoreManager = FirestoreManager() //Firebase --allows FirestoreManager to be accessed by app
    @StateObject var allitems = AllItems() // Menu+Basket
    @StateObject var category = Categories() // Landing+Menu
    @StateObject var showcategory = showCategories() // Landing+Menu
    
    //firebase stuff
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .ignoresSafeArea() // the home bar is causing 'safe area' below footer bar
                .environmentObject(firestoreManager) //sets it as an environment object to be accessed by app
                .environmentObject(viewRouter)
                .environmentObject(allitems)
                .environmentObject(category)
                .environmentObject(showcategory)
        }
    }
    

}

import SwiftUI //importing library for GUI features
import Firebase //importing library to communicate with Firebase Database


@main // entry point of App
struct Stodge: App {
    
    @StateObject var viewRouter = ViewRouter() //MotherView
    @StateObject var allitems = AllItems() // Menu+Basket
    @StateObject var category = Categories() // Landing+Menu
    @StateObject var showcategory = showCategories() // Landing+Menu
    @StateObject var basket = Basket() // Basket+Menu
    @StateObject var orders = Orders() // Orders
    
    init(){ // run when the function is first called
        FirebaseApp.configure() // initialises the connection to the firebase database
    }
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .ignoresSafeArea() // the home bar is causing 'safe area' below footer bar
                //sharing access to these structs' data
                .environmentObject(viewRouter)
                .environmentObject(allitems)
                .environmentObject(category)
                .environmentObject(showcategory)
                .environmentObject(basket)
                .environmentObject(orders)
        }
    }
}

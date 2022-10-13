import SwiftUI
import Firebase


@main
struct Stodge: App {
    
    @StateObject var viewRouter = ViewRouter() //MotherView
    @StateObject var allitems = AllItems() // Menu+Basket
    @StateObject var category = Categories() // Landing+Menu
    @StateObject var showcategory = showCategories() // Landing+Menu
    @StateObject var basket = Basket() // Basket+Menu
    @StateObject var orders = Orders() // Orders
    
    //firebase initialisation
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .ignoresSafeArea() // the home bar is causing 'safe area' below footer bar
                .environmentObject(viewRouter)
                .environmentObject(allitems)
                .environmentObject(category)
                .environmentObject(showcategory)
                .environmentObject(basket)
                .environmentObject(orders)
        }
    }
    

}

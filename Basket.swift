import SwiftUI
import Firebase

struct BasketPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter // sharing ViewRouter so that this struct has access to its data.
    @EnvironmentObject var basket: Basket // sharing Basket so that this struct has access to its data.
    @State var showPopover = false // toggles to true to show Confirm Details popover
    
    var body: some View{
            ZStack{
                Color.white // background color set to white
                    .ignoresSafeArea()
                VStack{
                
                    Header()
                    Text("Basket") // title 'Basket' is displayed
                        .font(.system(size: 50, weight: .bold))
                    
                    ScrollView(showsIndicators: false) {
                        if (basket.currentBasket.isEmpty){ // checks if basket is empty
                            Spacer()
                                .frame(height: 200)
                            Text("Basket is Empty...") // shows message if empty
                                .font(.system(size: 16, weight: .medium))
                        }else{
                            LazyVStack(alignment:.center) {
                                ForEach(basket.currentBasket) { product in // iterates through all items
                                    ItemInBasket(item: product) // displays every item in basket
                                }
                            }
                        }
                        Spacer()
                            .frame(height:120)
                    }
                    Spacer()
                    
                    //Displays total cost of products
                    Text("Total: £\(String(format: "%.2f", basket.totalCost))")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    //order button that leads to confirmation popup
                    Button{
                        print("Order")
                        print(basket.currentBasket)
                        if (basket.currentBasket.isEmpty == false){ // checks if basket is empty
                            showPopover.toggle() //show the confirm order popover
                        }else{
                            print("Basket is Empty...") // debug
                        }
                    }label:{
                        StdButton("Order")
                    }
                    
                    Spacer()
                        .frame(height:150)
                }
                VStack{
                    Spacer() // sets equal spacing between items displayed on the screen
                    Footer() // displays the page's footer
                    Spacer()
                        .frame(height: 40)
                }
                
                if (basket.showPopup == "OrderPlaced") { // popup for 'Order Placed'
                    popupWindow(image: "GreenTick", text: "Order Placed!")
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                basket.showPopup = ""
                            }
                        }
                } else if (basket.showPopup == "InsufficientStock") { // popup for 'Insufficient Stock'
                    popupWindow(image: "RedCross", text: "Insufficient Stock!")
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                basket.showPopup = ""
                            }
                        }
                    
                } else if (basket.showPopup == "InsufficientBalance") { // popup for 'Insufficient Balance'
                    popupWindow(image: "RedCross", text: "Insufficient Balance!")
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                basket.showPopup = ""
                            }
                        }
                    
                }
            
        }
        .popover(isPresented: $showPopover) { // checks if showPopover is true
            
           ConfirmOrder().colorScheme(.light) // show the Confirm Order popover
        }
    }
}

//-- Local Store of Current Basket --
//
//[ Item, Item2, Item3 ]

// if an item's quantity is zero, remove item


class Basket: ObservableObject {
    
    @Published var currentBasket: [Item] = [] //setting the original value of currentBasket as an @published value so that all structs are updated when its value changes
    @Published var totalCost = 0.00 // setting the original value of totalCost as an @published value
    @Published var showPopup = "" //setting the original value of showPopup as an @published value
    
    func calculateCost() {
        totalCost = 0 //resets the totalCost
        for item in currentBasket{ //iterates through all items in the basket
            totalCost = totalCost + Double(item.cost)! * Double(item.count) // multiply by quantity
        }
        print(totalCost) // debug
    }
}


struct ConfirmOrder: View{
    
    @EnvironmentObject var users: Users
    @EnvironmentObject var basket: Basket
    @EnvironmentObject var Orders: Orders
    @Environment(\.presentationMode) var presentationMode // sets the variable presentationMode to the view
    
    var body: some View {
        
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            VStack{
                Text("Order Summary") // displays Title
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top,40)
                
                
                // Items in current basket
                ScrollView(showsIndicators: false){
                    ForEach(basket.currentBasket) { product in
                        ItemtoConfirm(item:product)
                    }
                }
                
                
                Text("Total: £\(String(format: "%.2f", basket.totalCost))") // displays the total cost of basket
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.leading)
                
                Button{
                    print("Confirm") // debug
                    addOrder() // adds order to firebase
                    print("Order Placed!") // debug
                    presentationMode.wrappedValue.dismiss() // closes the popover
                }label:{
                    StdButton("Confirm") //displays confirm button with preset standard formatting for a button
                }
                
                Spacer()
                    .frame(height:20)
            }
        }
    }
    func addOrder(){
        if users.checkLimit(basket: basket) == true{ //checks if User has sufficient spent limit
            let db = Firestore.firestore() // links to firestore
            let OrderNum = String(Int(Double(Orders.all.count)) + 1) // Finds the number of Orders
            let orderCode = String(Int.random(in: 1000...9999)) // sets it as a random 4-digit number
            var orderItems: Dictionary<String, String> = [:] // storing all items from database as a dictionary
            for i in basket.currentBasket{
                orderItems[String(i.name)] = String(i.count) // adding items in basket as items in order
            }
            var ref: DocumentReference? = nil
            ref = db.collection("Orders").addDocument(data: [ //makes new 'order' document
                "Order Code": orderCode,
                "Order Number": OrderNum,
                "Order Time": Timestamp(date: Date()),
                "Items": orderItems,
                "isActive": "Y",
                "User": Auth.auth().currentUser!.uid,
                "TotalCost": String(basket.totalCost) // adds all values from current basket to Firestore database
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)") // debug - if database fails
                    } else {
                        print("Document added to 'Orders' with ID: \(ref!.documentID)") // debug
                    }
                }
            
            for i in basket.currentBasket{ //recalculates item stock quantities
                let doc = db.collection("Items").document(i.id)
                doc.updateData([
                    "Stock": String(Int(i.stock)! - i.count) // updates the stock of a certain item
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)") // debug - if database fails
                    } else {
                        print("'Stock' in 'Items' successfully updated") // debug
                    }
                }
            }
            
            // update spent
            let i = users.mainUser[0]
            let doc = db.collection("Users").document(i.id)
            doc.updateData([
                "Spent": String(Double(i.spent)! + basket.totalCost) // setting the amount spent by user to include latest order
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("'Spent' in 'Users' successfully updated")
                }
            }
            
            basket.currentBasket = [] // clears basket
            basket.calculateCost() // sets basket cost back to zero
            basket.showPopup = "OrderPlaced" // shows confirm
        } else { // if not enough spent limit left
            print("Insufficient Balance") // debug
            basket.showPopup = "InsufficientBalance" // shows popup that the user has insufficient balance
        }
    }
}

struct User: Identifiable{
    let id: String
    let name: String
    let password: String
    let UID: String
    let year: String
    let limit: String
    let spent: String
    let profilepic: String
    let code: String
}
let blankUser = User(id: "", name: "", password: "", UID: "", year: "", limit: "", spent: "", profilepic: "", code: "")
class Users: ObservableObject {
    
    @Published var all: [User] = [] // contains all Users in the database
    @Published var mainUser: [User] = [blankUser] // contains the user currently logged in
    @EnvironmentObject var basket: Basket // sharing Basket so that this struct has access to its data.
    
    init(){ // run when the class is initialised
        fetchAllUsers()
        findMainUser()
    }
    
    func fetchAllUsers() {
        let db = Firestore.firestore() // establishing connection with Firestore Database
        db.collection("Users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)") // debug
                return
            }
            // fetches all users from Firestore Database and maps its values to the custom object 'User' and stores them in an array
            self.all = documents.map { User(id: $0.documentID, name: "\($0["Name"]!)", password: "\($0["Password"]!)", UID: "\($0["UID"]!)", year: "\($0["Year"]!)", limit: "\($0["Limit"]!)", spent: "\($0["Spent"]!)" , profilepic: "\($0["ProfilePic"]!)", code: "\($0["Code"]!)") // $0 is first parameter
            }
            print("Users: \(self.all)") // debug
        }
    }
    
    func findMainUser() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Delay for 1.5 second
                    let currentUser = Auth.auth().currentUser!.uid // fetches the current User logged in
                    print(self.all) // debug
                    for user in self.all{
                        if user.UID == currentUser {
                            self.mainUser = [] //clearing the array
                            self.mainUser.append(user) // set mainUser[0] to the current user
                            print(" Main User: \(self.mainUser)") // debug
                        }
                    }
                }
            }
        }
    }
    
    func checkLimit(basket: Basket) -> Bool {
        findMainUser() // get the current lgoged in user and their details
        if mainUser[0].limit == "-1"{ // checks if user has no limit
            return true
        } else if ((Double(mainUser[0].spent)!) + basket.totalCost <= Double(mainUser[0].limit)!){ // checks if limit is not exceeded
            return true
        }
        else{ // if limit has been exceeded
            return false
        }
    }
}


struct BasketPreview: PreviewProvider {
    
    static var previews: some View {
        BasketPage()
    }
}


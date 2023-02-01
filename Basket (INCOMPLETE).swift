import SwiftUI
import Firebase

struct BasketPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var basket: Basket
    @State var showPopover = false
    
    var body: some View{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                
                    Header()
                    Text("Basket")
                        .font(.system(size: 50, weight: .bold))
                    
                    ScrollView(showsIndicators: false) { // list of items
                        if (basket.currentBasket.isEmpty){
                            Spacer()
                                .frame(height: 200)
                            Text("Basket is Empty...")
                                .font(.system(size: 16, weight: .medium))
                        }else{
                            LazyVStack(alignment:.center) {
                                ForEach(basket.currentBasket) { product in
                                    ItemInBasket(item: product)
                                }
                            }
                        }
                        Spacer()
                            .frame(height:120)
                    }
                    Spacer()
                    
                    //Displays total cost of products
                    //Cost = String(format: "%.2f", Cost) // round to two d.p. as a price
                    Text("Total: £\(String(format: "%.2f", basket.totalCost))")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    //order button that leads to confirmation popup
                    Button{
                        print("Order")
                        print(basket.currentBasket)
                        if (basket.currentBasket.isEmpty == false){
                            showPopover.toggle()
                        }else{
                            print("Basket is Empty...")
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
                
                //popup for 'Order Placed'
                if (basket.showPopup == "OrderPlaced") {
                    popupWindow(image: "GreenTick", text: "Order Placed!")
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                basket.showPopup = ""
                            }
                        }
                } else if (basket.showPopup == "InsufficientStock") {
                    popupWindow(image: "RedCross", text: "Insufficient Stock!")
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                basket.showPopup = ""
                            }
                        }
                    
                } else if (basket.showPopup == "InsufficientBalance") {
                    popupWindow(image: "RedCross", text: "Insufficient Balance!")
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                basket.showPopup = ""
                            }
                        }
                    
                }
            
        }
        .popover(isPresented: $showPopover) {
            
           ConfirmOrder().colorScheme(.light)
            
        }
    }
}

//-- Local Store of Current Basket --
//
//[ Item, Item2, Item3 ]

// if an item's quantity is zero, remove item


//var CurrentBasket: [Item]


class Basket: ObservableObject {
    
    @Published var currentBasket: [Item] = []
    @Published var totalCost = 0.00
    @Published var showPopup = ""
    
    func calculateCost() {
        totalCost = 0
        for item in currentBasket{
            totalCost = totalCost + Double(item.cost)! * Double(item.count) // multiply by quantity
        }
        print(totalCost)
    }
}


struct ConfirmOrder: View{
    
    @EnvironmentObject var users: Users
    @EnvironmentObject var basket: Basket
    @EnvironmentObject var Orders: Orders
    @Environment(\.presentationMode) var presentationMode // sets the variable presentationMode to the view
    
    var body: some View {
        //Title
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            VStack{
                Text("Order Summary")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top,40)
                
                
                //Items in current basket
                ScrollView(showsIndicators: false){
                    ForEach(basket.currentBasket) { product in
                        ItemtoConfirm(item:product)
                    }
                }
                
                
                Text("Total: £\(String(format: "%.2f", basket.totalCost))")
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.leading)
                
                //order button that leads to confirmation popup
                Button{
                    print("Confirm")
                    addOrder()
                    print("Order Placed!")
                    presentationMode.wrappedValue.dismiss() // closes the popover
                }label:{
                    StdButton("Confirm")
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
            let orderCode = String(Int.random(in: 1000...9999))
            var orderItems: Dictionary<String, String> = [:]
            for i in basket.currentBasket{
                orderItems[String(i.name)] = String(i.count)
            }
            var ref: DocumentReference? = nil
            ref = db.collection("Orders").addDocument(data: [ //makes new 'order' document
                "Order Code": orderCode,
                "Order Number": OrderNum,
                "Order Time": Timestamp(date: Date()),
                "Items": orderItems,
                "isActive": "Y",
                "User": Auth.auth().currentUser!.uid,
                "TotalCost": String(basket.totalCost)
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added to 'Orders' with ID: \(ref!.documentID)")
                    }
                }
            
            for i in basket.currentBasket{ //recalculates item stock quantities
                let doc = db.collection("Items").document(i.id)
                doc.updateData([
                    "Stock": String(Int(i.stock)! - i.count)
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("'Stock' in 'Items' successfully updated")
                    }
                }
            }
            
            // update spent
            let i = users.mainUser[0]
            let doc = db.collection("Users").document(i.id)
            doc.updateData([
                "Spent": String(Double(i.spent)! + basket.totalCost)
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("'Spent' in 'Users' successfully updated")
                }
            }
            
            basket.currentBasket = [] // clears basket
            basket.calculateCost()
            basket.showPopup = "" // shows confirm
        } else { // if not enough spent limit left
            print("Insufficient Balance")
            basket.showPopup = "InsufficientBalance"
        }
    }
}

class Users: ObservableObject {
    
    @Published var all: [User] = []
    @Published var mainUser: [User] = []
    @EnvironmentObject var basket: Basket
    
    init(){
        fetchAllUsers()
        findMainUser()
    }
    
    func fetchAllUsers() {
        let db = Firestore.firestore()
        db.collection("Users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.all = documents.map { User(id: $0.documentID, name: "\($0["Name"]!)", password: "\($0["Password"]!)", UID: "\($0["UID"]!)", year: "\($0["Year"]!)", limit: "\($0["Limit"]!)", spent: "\($0["Spent"]!)") // $0 is first parameter
            }
            print("Users: \(self.all)")
        }
    }
    
    func findMainUser() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                    let currentUser = Auth.auth().currentUser!.uid
                    //print("OK!")
                    //print(self.all)
                    for user in self.all{
                        //print("Loop")
                        if user.UID == currentUser {
                            self.mainUser = []
                            self.mainUser.append(user) //set mainUser[0]
                            print(" Main User: \(self.mainUser)")
                        }
                    }
                }
            }
        }
    }
    
    func checkLimit(basket: Basket) -> Bool {
        findMainUser()
        if mainUser[0].limit == "-1"{
            return true
        } else if ((Double(mainUser[0].spent)!) + basket.totalCost <= Double(mainUser[0].limit)!){
            return true
        }
        else{
            return false
        }
    }
}


struct BasketPreview: PreviewProvider {
    
    static var previews: some View {
        BasketPage()
    }
}


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
    
    func calculateCost() {
        totalCost = 0
        for item in currentBasket{
            totalCost = totalCost + Double(item.cost)! * Double(item.count) // multiply by quantity
        }
        print(totalCost)
    }
}


struct ConfirmOrder: View{
    
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
        let db = Firestore.firestore() // links to firestore
        let lastOrder = String(Int(Orders.all.last!.number)! + 1) // BROKEN NOT WORKING
        let orderCode = String(Int.random(in: 1000...9999))
        var orderItems: Dictionary<String, String> = [:]
        for i in basket.currentBasket{
            orderItems[String(i.name)] = String(i.count)
        }
        var ref: DocumentReference? = nil
        ref = db.collection("Orders").addDocument(data: [ //makes new 'order' document
            "Order Code": orderCode,
            "Order Number": lastOrder,
            "Order Time": Timestamp(date: Date()),
            "Items": orderItems,
            "isActive": "Y"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        for i in basket.currentBasket{
            let doc = db.collection("Items").document(i.id) //recalculates item stock quantities
            doc.updateData([
                "Stock": String(Int(i.stock)! - i.count)
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        
        basket.currentBasket = []
        basket.calculateCost()
    }
}

struct BasketPreview: PreviewProvider {
    
    static var previews: some View {
        BasketPage()
    }
}


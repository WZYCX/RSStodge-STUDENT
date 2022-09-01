import SwiftUI

struct BasketPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var cost = 0.00
    @State var showPopover = false
    
    var body: some View{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                
                    Header()
                    ScrollView(showsIndicators: false) { // list of items
                        Text("Basket")
                            .font(.system(size: 50, weight: .bold))
                        LazyVStack(alignment:.center) {
                            ForEach(1...5, id: \.self) { _ in
                            ItemInBasket(itemImage: "LiptonIceTea", itemName: "Lipton Ice Tea (Lemon)", count: 1)
                            }
                        }
                    }
                    Spacer()
                    
                    //Displays total cost of products
                    //Cost = String(format: "%.2f", Cost) // round to two d.p. as a price
                    Text("Total: £\(String(format: "%.2f", cost))")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    //order button that leads to confirmation popup
                    Button{
                        print("Order")
                        showPopover.toggle()
                    }label:{
                        StdButton("Order")
                    }
                    
                    Spacer()
                        .frame(height:20)
                    
                    Footer()
            }
            
        }
        .popover(isPresented: $showPopover) {
            
           ConfirmOrder()
            
        }
    }
}

//-- Local Store of Current Basket --
//
//[ Cost, [item1, quantity1] , [item2, quantity2] , [item3, quantity3] ]

// if an item's quantity is zero, remove item


//var CurrentBasket: [[BasketItem]]

struct BasketItem: Identifiable{
    let id: Int
    let name: String
    let desc: String
    let cost: Float
    let category: String
    var Count: Int
}

class Basket: ObservableObject {
    
    @Published var currentBasket: [[BasketItem]] = [[]]
    
}


struct ConfirmOrder: View{
    
    @Environment(\.presentationMode) var presentationMode // sets the variable presentationMode to the view
    @State var cost = 0.00

    var body: some View {
        //Title
        ZStack{
            Color.white
            
            VStack{
                Text("Order Summary")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top,40)
                
                
                //Items in current basket
                ScrollView(showsIndicators: false){
                    ForEach(1...6, id: \.self) { _ in
                        ItemtoConfirm(itemImage: "LiptonIceTea", itemName: "Lipton Ice Tea (Lemon)", cost: 0.00, count: 1)
                    }
                }
                
                
                Text("Total: £\(String(format: "%.2f", cost))")
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.leading)
                
                //order button that leads to confirmation popup
                Button{
                    print("Confirm")
                    presentationMode.wrappedValue.dismiss() // closes the popover
                }label:{
                    StdButton("Confirm")
                }
                
                Spacer()
                    .frame(height:20)
            }
        }
    }
}

struct BasketPreview: PreviewProvider {
    
    static var previews: some View {
        BasketPage()
    }
}


import SwiftUI

struct BasketPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var basket: Basket
    @State var cost = 0.00
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
                        .frame(height:20)
                    
                    Footer()
            }
            
        }
        .popover(isPresented: $showPopover) {
            
           ConfirmOrder().colorScheme(.light)
            
        }
    }
}

//-- Local Store of Current Basket --
//
//[ Cost, [item1, quantity1] , [item2, quantity2] , [item3, quantity3] ]

// if an item's quantity is zero, remove item


//var CurrentBasket: [[BasketItem]]


class Basket: ObservableObject {
    
    @Published var currentBasket: [Item] = []
    
}


struct ConfirmOrder: View{
    
    @EnvironmentObject var basket: Basket
    @Environment(\.presentationMode) var presentationMode // sets the variable presentationMode to the view
    @State var cost = 0.00

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


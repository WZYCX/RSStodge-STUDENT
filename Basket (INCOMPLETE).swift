import SwiftUI

struct BasketPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State var Cost = 0.00
    
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
                            ForEach(1...3, id: \.self) { _ in
                            ItemInBasket(itemImage: "LiptonIceTea", itemName: "Lipton Ice Tea (Lemon)", count: 1)
                            }
                        }
                    }
                    Spacer()
                    
                    //Displays total cost of products
                    //Cost = String(format: "%.2f", Cost) // round to two d.p. as a price
                    Text("Total: £\(String(format: "%.2f", Cost))")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.leading)
                    
                    //order button that leads to confirmation popup
                    Button{
                        print("Order")
                    }label:{
                        StdButton("Order")
                    }
                    
                    Spacer()
                        .frame(height:20)
                    
                    Footer()
                }
            
        }
    }
}

//-- Local Store of Current Basket --
//
//[ Cost, [item1, quantity1] , [item2, quantity2] , [item3, quantity3] ]

// if an item's quantity is zero, remove item


struct BasketPreview: PreviewProvider {
    
    static var previews: some View {
        BasketPage()
    }
}


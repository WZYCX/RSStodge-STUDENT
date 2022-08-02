import SwiftUI

struct BasketPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                
                    Header()
                    ScrollView { // list of items
                        Text("Basket")
                            .font(.system(size: 50, weight: .bold))
                        LazyVStack(alignment:.center) {
                            ForEach(1...3, id: \.self) { _ in
                            ItemInBasket(itemImage: "LiptonIceTea", itemName: "Lipton Ice Tea (Lemon)", count: 1)
                            }
                        }
                    }
                    Spacer()
                    Footer()
                }
            
        }
    }
}


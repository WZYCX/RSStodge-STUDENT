import SwiftUI

struct MenuPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                
                    Header()
                    Text("Items")
                        .font(.system(size: 50, weight: .bold))
                    
                    ScrollView { // list of items
                        LazyVStack(alignment:.center) {
                        
                            ForEach(1...10, id: \.self) { _ in // duplicate by 10
                                ItemToSell(itemImage: "LiptonIceTea", itemName: "Lipton Ice Tea (Lemon)")
                            }.padding(10)
                        }
                    }
                    Spacer()
                    Footer()
                }
            
        }
    }
}


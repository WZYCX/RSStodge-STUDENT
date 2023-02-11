import SwiftUI

struct OrdersPage: View{
    
    @State var isActive = true // sets the orders to view as 'Active'
    @EnvironmentObject var Orders: Orders // sharing Orders so that this struct has access to its data.
    @EnvironmentObject var basket: Basket // sharing Basket so that this struct has access to its data.
    
    var body: some View{
        ZStack{
            Color.white // background colour set to white
                .ignoresSafeArea()
            VStack{
                Header()
                Text("Orders") //title
                    .padding()
                    .font(.system(size: 50, weight: .semibold))
                
                HStack{
                    Button{ // Active Orders button
                        withAnimation{
                            isActive = true // sets orders to show as 'Active'
                            print("Active") // debug
                        }
                    }label: {
                        Text("Active") // displays 'Active'
                            .frame(width: 80, height: 30)
                            .background(.red)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .cornerRadius(8,corners: [.topLeft,.bottomLeft])
                    }
                    Button{ // Past Orders button
                        withAnimation{
                            isActive = false // sets orders to show as 'Past'
                            print("Past") // debug
                        }
                    }label: {
                        Text("Past") // displays 'Past'
                            .frame(width: 80, height: 30)
                            .background(.red)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .cornerRadius(8,corners: [.topRight,.bottomRight])
                    }
                }
                ScrollView(showsIndicators: false){ // allows scrolling
                    if (isActive == true){ // if 'Active' orders are to be shown
                        ForEach(Orders.all){ Order in
                            OrderInView(Order: Order, Active: "Y") // displays all orders that are 'Active'
                        }
                    }else { //  if isActive == false
                        ForEach(Orders.all){ Order in
                            OrderInView(Order: Order, Active: "N") // displays all orders that are 'Past'
                        }
                    }
                    Spacer()
                        .frame(height:120)
                }
            }
            VStack{
                Spacer() // sets equal spacing between items displayed on the screen
                Footer() // displays the page's footer
                Spacer()
                    .frame(height: 40)
            }
            
            if (basket.showPopup == "OrderCancelled") {
                popupWindow(image: "GreenTick", text: "Order Cancelled!")
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            basket.showPopup = ""
                        }
                    }
            }
        }
    }
}

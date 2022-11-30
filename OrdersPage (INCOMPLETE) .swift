import SwiftUI

struct OrdersPage: View{
    
    @State var isActive = true
    @EnvironmentObject var Orders: Orders
    
    var body: some View{
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack{
                Header()
                Text("Orders")//placeholder for "Hi \n\(name)"
                    .padding()
                    .font(.system(size: 50, weight: .semibold))
                
                HStack{
                    Button{ //Active
                        withAnimation{
                            isActive = true
                            print("Active")
                        }
                    }label: {
                        Text("Active")
                            .frame(width: 80, height: 30)
                            .background(.red)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .cornerRadius(8,corners: [.topLeft,.bottomLeft])
                    }
                    Button{ //Past
                        withAnimation{
                            isActive = false
                            print("Past")
                        }
                    }label: {
                        Text("Past")
                            .frame(width: 80, height: 30)
                            .background(.red)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .cornerRadius(8,corners: [.topRight,.bottomRight])
                    }
                }
                ScrollView(showsIndicators: false){
                    if (isActive == true){
                        ForEach(Orders.all){ Order in
                            OrderInView(Order: Order)
                        }
                    }else { //  if isActive == false
                        ForEach(Orders.all){ Order in
                            OrderInView(Order: Order)
                        }
                    }
                }
            }
            VStack{
                Spacer() // sets equal spacing between items displayed on the screen
                Footer() // displays the page's footer
                Spacer()
                    .frame(height: 40)
            }
        }
    }
}

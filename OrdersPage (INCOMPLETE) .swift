import SwiftUI

struct OrdersPage: View{
    
    @State var isActive = true
    
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
                            isActive = true
                            print("Active")
                        }label: {
                            Text("Active")
                                .frame(width: 80, height: 30) 
                                .background(.red)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .cornerRadius(8,corners: [.topLeft,.bottomLeft])
                        }
                        Button{ //Past
                            isActive = false
                            print("Past")
                        }label: {
                            Text("Past")
                                .frame(width: 80, height: 30) 
                                .background(.red)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .cornerRadius(8,corners: [.topRight,.bottomRight])
                        }
                    }
                    ScrollView{
                    if (isActive == true){
                        ForEach(1...10, id:\.self){ _ in
                            Order(OrderID: 1234, OrderContents: ["Chicken Sandwich","Water","Appletiser"], OrderTime: "11:32", OrderCode: "XJ24")
                        }
                    }
                    
                    }
                    Spacer()
                    Footer()
                    
                }
        }
    }
}

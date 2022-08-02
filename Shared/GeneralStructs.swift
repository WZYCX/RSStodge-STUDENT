import SwiftUI
import Foundation

struct RoundedCorner: Shape { // for 'corners' parameter of cornerRadius
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View { // for 'corners' parameter of cornerRadius
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RSStodgeLogo: View {
    
    var textSize: CGFloat
    var ImageSize: CGFloat
    
    var body: some View {
        HStack{
            VStack (alignment: .leading){
                Text("Rugby School")
                    .font(.system(size: textSize, weight: .semibold))
                Text("Stodge")
                    .font(.system(size: textSize, weight: .semibold))
            } .padding(.horizontal,5)
            
            Image("RSLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ImageSize)
        }
    }
}

struct InputBox: View{
    var Stuff : String
    var matchingState: Binding<String>
    var IsSecure : Bool
    var body: some View{
        if IsSecure{
            SecureField(Stuff, text: matchingState)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(.cyan) //change cursor colour
                .frame(width: 300, height: 50)
        }else{
            TextField(Stuff, text: matchingState)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(.cyan) //change cursor colour
                .frame(width: 300, height: 50)
        }

        
    }
}

struct HeaderButton: View{
    
    var ButtonName: Page
    var ButtonSymbol: String
    var LeadingorTrailing: Edge.Set
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View{
        
        Button{
            print("Direct to right place")
            viewRouter.currentPage = ButtonName
            
        }label: {
            Image(systemName: ButtonSymbol)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
        }
        .padding(LeadingorTrailing,10)
        .padding(.top,5)
        .foregroundColor(.red)
    }
}


struct Header: View{
    
    var body: some View{
        
        ZStack{
            RSStodgeLogo(textSize: 20, ImageSize: 50)
                HStack{
                    HeaderButton(ButtonName: .LogIn, ButtonSymbol: "arrow.left.to.line.circle.fill", LeadingorTrailing: .leading)
                    Spacer()
                    HeaderButton(ButtonName: .Basket, ButtonSymbol: "cart.circle.fill", LeadingorTrailing: .trailing)
            }
            
        }.padding(.top,50)
    }
}

struct FooterButton: View{
    
    var DirectTo: Page
    var ButtonSymbol: String
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View{
        Button{
            print("Direct to right place")
            withAnimation {
                viewRouter.currentPage = DirectTo
            }
            
        }label: {
            Image(systemName: ButtonSymbol)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .foregroundColor(.white)
        }
    }
}

struct Footer: View{
    var body: some View{
        
        HStack{
            Spacer()
            FooterButton(DirectTo: .Landing, ButtonSymbol: "house.fill")
            Spacer()
            FooterButton(DirectTo: .Menu, ButtonSymbol: "takeoutbag.and.cup.and.straw.fill")
            Spacer()
            FooterButton(DirectTo: .Orders, ButtonSymbol: "list.bullet")
            Spacer()
            FooterButton(DirectTo: .Account, ButtonSymbol: "person.circle")
            Spacer()
            // to be completed
        }.frame(maxWidth:.infinity)
            .frame(height: 100)
            .background(.red)
            .cornerRadius(10, corners:[.topLeft,.topRight])
            
    }
}

//landing

struct NewsStory: View{
    
    var NewsTitle: String
    var NewsBody: String
    
    var body: some View{
        VStack(alignment:.leading){
            Text("\(NewsTitle)\n")
                .font(.system(size: 28, weight: .bold))
            Text("\(NewsBody)\n\n")
        }
    }
}

struct NewsBox: View{
    
    var stories : [[String]] // [["Title1","Body1"] , ["Title2","Body2"]]
    @State var more = false 
    // more button to show ALL NEWS
    
    var body: some View{
        VStack{
            VStack{
                VStack{
                    LazyVStack(alignment: .leading){
                        ForEach(0...2, id:\.self){ i in //only
                            NewsStory(NewsTitle: stories[i][0], NewsBody: stories[i][1])
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 300, maxHeight: 1000)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.red, lineWidth: 5)
            )
        }
    } 
} 

//Menu
struct ItemToSell: View{
    
    var itemImage: String
    var itemName: String
    
    var body: some View{
        HStack{//Item placeholder
            Image(itemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            VStack{             
                Text(itemName)
                    .font(.system(size: 18, weight: .medium))
                Button{
                    print("You like Lipton Ice Tea and LGBTea!!! WOOOOO!!!") // add to basket (To Be Completed...)
                }label:{
                    Text("Add")
                        .frame(width: 80, height: 20)
                        .background(.red)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct Order: View{
    
    //var active: String
    var OrderID: Int
    var OrderContents: Array<String>
    var OrderTime: String // change to NSDate() or something that is actually the time
    var OrderCode: String
    
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Text("Order #\(String(OrderID))")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
                
                Text("\(OrderTime)")
            }
            VStack(alignment:.leading){
            ForEach(OrderContents, id:\.self){ i in
                Text("\(i)")
            }
            }
        }
        .padding()
        .border(.black, width: 3)
        
    }
}

//account

struct UserDetails: View{
    
    
    var ProfileImage: String
    var Name: String
    var Year: String
    var StodgeID: String
    
    
    var body: some View{
        VStack{
            Image(ProfileImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding(.bottom,50)
            VStack(alignment: .leading){
                Text("Name: \(Name)")
                Text("Year: \(Year)")
                Text("Stodge ID: \(StodgeID)")
            }.font(.system(size: 20, weight: .medium))
        }
    }
}

//basket

var Basket = [[]]

struct BasketItem: Identifiable{
    let id: Int
    let name: String
    let desc: String
    let cost: Float
    let category: String
    var Count: Int
}

struct ItemInBasket: View{
    
    var itemImage: String
    var itemName: String
    @State var count: Int
    
    var body: some View{
        HStack{//Item placeholder
            Image(itemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            VStack{             
                Text(itemName)
                    .font(.system(size: 18, weight: .medium))
                HStack{
                    // add or remove counter
                    HStack{ 
                        Button{
                            if (count > 1) {
                                count = count - 1
                                print("Removed one")
                                
                            } else if (count == 1){
                                print("Item removed")
                                count = 0
                            }
                        }label:{
                            Text("-")
                                .frame(width: 30, height: 25)
                                .background(.red)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .cornerRadius(10,corners: [.topLeft,.bottomLeft])
                        }
                        Text(String(count))
                            .frame(width: 30, height: 25)
                            .background(.white)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                            .border(.black, width: 1)
                        Button{
                            print("Added one") 
                            count = count + 1
                        }label:{
                            Text("+")
                                .frame(width: 30, height: 25) 
                                .background(.red)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .cornerRadius(10,corners: [.topRight,.bottomRight])
                        }
                    }
                    //Remove Item button
                    Button{
                        print("Item Removed") // remove from basket (To Be Completed...)
                    }label:{
                        Image(systemName: "trash.fill")
                            .frame(width: 80, height: 25)
                            .background(.red)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }.padding(.leading,20)
                }
                
            }
        }
    }
}

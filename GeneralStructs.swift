import SwiftUI
import Firebase

// for 'corners' parameter of cornerRadius
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// for 'corners' parameter of cornerRadius
extension View {
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
                Text("STUDENT")
                    .font(.system(size: textSize, weight: .semibold))
                    .foregroundColor(.blue)
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
    
    var ButtonSymbol: String
    var LeadingorTrailing: Edge.Set
    var isLogOut: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View{
        
        Button{
            print("Direct to right place")
            if isLogOut == true {
                do{
                    print("Signing out...")
                    try Auth.auth().signOut()
                        
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                }
                
            } else {
                withAnimation {
                    viewRouter.currentPage = .Basket
                }
            }
            
        }label: {
            Image(systemName: ButtonSymbol)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
        }
        .padding(LeadingorTrailing,10)
        .padding(.top,5)
        .foregroundColor(.red)
    }
}


struct Header: View{
    
    var body: some View{
        
        ZStack{
            RSStodgeLogo(textSize: 16, ImageSize: 40)
                HStack{
                    HeaderButton(ButtonSymbol: "arrow.left.to.line.circle.fill", LeadingorTrailing: .leading,isLogOut: true)
                    Spacer()
                    HeaderButton(ButtonSymbol: "cart.circle.fill", LeadingorTrailing: .trailing, isLogOut: false)
            }
            
        }.padding(.top,50)
    }
}

struct FooterButton: View{
    
    var DirectTo: Page
    var ButtonSymbol: String
    var Caption: String
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View{
        VStack{
            Button{
                print("Direct to right place")
                withAnimation {
                    viewRouter.currentPage = DirectTo
                }
                
            }label: {
                Image(systemName: ButtonSymbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundColor(.white)
            }
            Text(Caption)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct Footer: View{
    var body: some View{
        
        HStack{
            Spacer()
               .frame(width:40)
            FooterButton(DirectTo: .Landing, ButtonSymbol: "house.fill", Caption: "Home")
            Spacer()
            FooterButton(DirectTo: .Menu, ButtonSymbol: "takeoutbag.and.cup.and.straw.fill", Caption: "Menu")
            Spacer()
            FooterButton(DirectTo: .Orders, ButtonSymbol: "list.bullet", Caption: "Orders")
            Spacer()
            FooterButton(DirectTo: .Account, ButtonSymbol: "person.circle", Caption: "Account")
            Spacer()
                .frame(width:40)
            // to be completed
        }.frame(maxWidth:.infinity)
            .frame(height: 100)
            .background(.red)
            //.cornerRadius(10, corners:[.topLeft,.topRight])
            
    }
}

//set the StdButton(text: "") to the standard
func StdButton(_ text: String) -> some View {
        let text = Text(text)
        .frame(width: 200, height: 50)
        .background(.red)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.white)
        .cornerRadius(10)
        
        return text
}

//landing

struct MenuStackButton: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var category: Categories
    @EnvironmentObject var showcategory: showCategories
    var textsize: CGFloat
    var text: String
    var image: String
    
    var body: some View{
        Button{
            // sets the category to whatever
            category.CurrentCategory = text
            print(category.CurrentCategory)
            // directs to Menu Page
            viewRouter.currentPage = .Menu
            // the dropdown menu hiding
                showcategory.show = false

        }label: {
            ZStack{
                //Color.red
                Color.gray
                  .opacity(0.2)
                HStack{
                    Spacer()
                        .frame(width:10)
                    VStack{
                        Spacer()
                        Text(text)
                            .font(.system(size: textsize,weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                            .frame(height: 10)
                    }
                    Spacer()
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60,height: 60)
                    Spacer()
                        .frame(width:10)
                    
                }
            }
            .frame(width: 160,height: 80)
            .cornerRadius(10)
        }
    }
}

struct MenuStack: View{
    
    var body: some View{
        VStack{
            HStack(alignment: .center){
                
                MenuStackButton(textsize: 16, text: "All", image: "both")
                //
                MenuStackButton(textsize: 16, text: "Snacks", image: "crisps")
            }
                
            HStack(alignment: .center){
                MenuStackButton(textsize: 16, text: "Drinks", image: "coladrink")
                //
                MenuStackButton(textsize: 16, text: "Hot Food", image: "burgercolour")
            }
            
        }
    }
}

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
        VStack(alignment: .leading){
            ForEach(0...2, id:\.self){ i in //only
                VStack(alignment:.leading){
                    Rectangle()
                        .frame(height:5)
                        .foregroundColor(.gray.opacity(0.1))
                    NewsStory(NewsTitle: stories[i][0], NewsBody: stories[i][1])
                        .padding(.leading,20)
                }
            }
        }
    }
} 

//Menu

struct DropdownButton: View {
    
    @EnvironmentObject var category: Categories
    @EnvironmentObject var showcategory: showCategories
    var text: String
    
    var body: some View{
        ZStack{
            if text == category.CurrentCategory {
                Color.red
                    .opacity(0.9)
            }else{
                Color.white
            }
            Button{
                category.CurrentCategory = text
                print(category.CurrentCategory)
                //withAnimation{ // animates the dropdown menu
                    showcategory.show = false
                //}
            }label:{
                Text(text)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
    }
}

class Categories: ObservableObject {
    
    @Published var CurrentCategory = "All"
    
}

class showCategories: ObservableObject{
    @Published var show = false
}

struct Dropdown: View{
    
    @EnvironmentObject var category: Categories
    
    var body: some View{
        VStack{
            Divider()
            DropdownButton(text: "All")
            Divider()
            DropdownButton(text: "Snacks")
            Divider()
            DropdownButton(text: "Drinks")
            Divider()
            DropdownButton(text: "Hot Food")
            Divider()
        }
    }
}

struct Item: Identifiable{
    let id: String
    let name: String
    let desc: String
    let cost: String
    let category: String
    let image: String
    var count: Int
}

//how the item is displayed when shown on MenuPage
struct ItemToSell: View{
    
    @EnvironmentObject var Category: Categories
    @EnvironmentObject var basket: Basket
    @State var item: Item
    
    var body: some View{
        
        //checking if item matches category selected
        if Category.CurrentCategory == "All" || item.category == Category.CurrentCategory{
            
            
            HStack{//Item placeholder
                
                //load item's image
                AsyncImage(url: URL(string: item.image)!, content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100,height:100)
                }, placeholder: {
                    ProgressView()
                })
                
                Spacer()
                //details + add button
                VStack{
                    Text(item.name)
                        .font(.system(size: 18, weight: .medium))
                    
                    Button{
                        print("Added item")
                        item.count+=1
                        basket.currentBasket.append(item)
                        print(basket.currentBasket)
                        //add item to basket
                        //you can add two of the same into 'basket'
                    }label:{
                        Text("Add")
                            .frame(width: 80, height: 20)
                            .background(.red)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                    }
                }
                Spacer()
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
            AsyncImage(url: URL(string: ProfileImage)!, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
            }, placeholder: {
                ProgressView()
            })
            .padding(.bottom,40)
            VStack(alignment: .leading){
                Text("Name: \(Name)")
                Text("Year: \(Year)")
                Text("Stodge ID: \(StodgeID)")
            }.font(.system(size: 20, weight: .medium))
        }
    }
}

//basket


struct ItemInBasket: View{
    
    
    @State var item: Item
    @EnvironmentObject var basket: Basket
    
    var body: some View{
        HStack{//Item placeholder
            AsyncImage(url: URL(string: item.image)!, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100,height:100)
            }, placeholder: {
                ProgressView()
            })
            
            VStack{             
                Text(item.name)
                    .font(.system(size: 18, weight: .medium))
                HStack{
                    // add or remove counter
                    HStack{ 
                        Button{
                            if (item.count > 1) {
                                item.count = item.count - 1
                                print("Removed one")
                                
                            } else if (item.count == 1){
                                print("Item removed")
                                item.count = 0
                                basket.currentBasket = basket.currentBasket.filter{$0.name != item.name}
                                print(basket.currentBasket)
                                
                            }
                        }label:{
                            Text("-")
                                .frame(width: 30, height: 25)
                                .background(.red)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .cornerRadius(10,corners: [.topLeft,.bottomLeft])
                        }
                        Text(String(item.count))
                            .frame(width: 30, height: 25)
                            .background(.white)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                            .border(.black, width: 1)
                        Button{
                            print("Added one") 
                            item.count = item.count + 1 //does not save the change to the basket but locally (resets when clicking off page)
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
                        item.count = 0
                        basket.currentBasket = basket.currentBasket.filter{$0.name != item.name}
                        print(basket.currentBasket)
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


struct ItemtoConfirm: View{
    
    @State var item: Item
    
    var body: some View{
        HStack{//Item placeholder
            
            AsyncImage(url: URL(string: item.image)!, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100,height:100)
            }, placeholder: {
                ProgressView()
            })
            
            VStack{
                Text(item.name)
                    .font(.system(size: 18, weight: .medium))
                HStack{
                    Text("Quantity: \(item.count)")
                    Text("Cost: £\(String(format: "%.2f", item.cost))")
                }
            }
        }
    }
}

import SwiftUI
import Firebase

// for 'corners' parameter of cornerRadius
struct RoundedCorner: Shape { // struct that allows certain corners of an object to be rounded
    var radius: CGFloat = .infinity // input value of radius
    var corners: UIRectCorner = .allCorners // input which corner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath) // changes the corner to rounded
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) ) // apply the rounded corners to the object in view
    }
}


struct RSStodgeLogo: View {
    
    var textSize: CGFloat // inputted value of size of text
    var ImageSize: CGFloat // inputted value of size of image
    
    var body: some View {
        HStack{
            VStack (alignment: .leading){
                Text("Rugby School") // displays text
                    .font(.system(size: textSize, weight: .semibold))
                Text("Stodge") // displays text
                    .font(.system(size: textSize, weight: .semibold))
                Text("STUDENT") // displays text
                    .font(.system(size: textSize, weight: .semibold))
                    .foregroundColor(.blue)
            } .padding(.horizontal,5)
            
            Image("RSLogo") // displays image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ImageSize) // sets the size of the image to inputted size
        }
    }
}

struct InputBox: View{
    var Stuff : String //text displayed in input box
    var matchingState: Binding<String> // the private variable storing this value
    var IsSecure : Bool // decides whether or not the input box censors numbers for Password
    var body: some View{
        if IsSecure{
            SecureField(Stuff, text: matchingState) // creates a censored input box if so
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(.cyan) //change cursor colour
                .frame(width: 300, height: 50)
        }else{
            TextField(Stuff, text: matchingState) // creates a normal input box if so
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(.cyan) //change cursor colour
                .frame(width: 300, height: 50)
        }

        
    }
}

struct HeaderButton: View{
    
    var ButtonSymbol: String // the name of the symbol displayed
    var LeadingorTrailing: Edge.Set // dictates whether it is left or right of the header
    var isLogOut: Bool // determines whether or not the button should log out or navigate to basket
    @EnvironmentObject var viewRouter: ViewRouter // sharing ViewRouter so that this struct has access to its data
    
    var body: some View{
        
        Button{
            print("Direct to right place") // debug - outputs to console if button functions
            if isLogOut == true {
                do{
                    viewRouter.currentPage = .Splash
                    print("Signing out...") // debug - outputs to console the program is trying to sign the user out
                    try Auth.auth().signOut() // attempting to sign out user
                        
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError) // debug - outputs to console if there is an erroring signing out
                }
                
            } else {
                withAnimation {
                    viewRouter.currentPage = .Basket // displays the basket page if 'isLogOut'is false
                }
            }
            
        }label: {
            Image(systemName: ButtonSymbol) // displays the button as the inputted button type
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50) // sets size to 50px
        }
        .padding(LeadingorTrailing,10) // sets whether the button is left or right
        .padding(.top,5)
        .foregroundColor(.red)
    }
}


struct Header: View{
    
    var body: some View{
        
        ZStack{
            RSStodgeLogo(textSize: 16, ImageSize: 40) // displays the RS Stodge Logo
                HStack{
                    HeaderButton(ButtonSymbol: "arrow.left.to.line.circle.fill", LeadingorTrailing: .leading,isLogOut: true) // displays the sign out button
                    Spacer() // sets equal spacing between items displayed on the screen
                    HeaderButton(ButtonSymbol: "cart.circle.fill", LeadingorTrailing: .trailing, isLogOut: false) // displays the basket button
            }
            
        }.padding(.top,50)
    }
}

struct FooterButton: View{
    
    var DirectTo: Page // inputted destination to navigate to
    var ButtonSymbol: String // the name of the symbol displayed
    var Caption: String // name of the button
    @EnvironmentObject var viewRouter: ViewRouter // sharing ViewRouter so that this struct has access to its data
    
    var body: some View{
        VStack{
            Button{
                print("Direct to right place") // debug - outputs to console if button functions
                withAnimation {
                    viewRouter.currentPage = DirectTo // displays and navigates to the inputted page
                }
                
            }label: {
                Image(systemName: ButtonSymbol) // displays image of the inputted button type
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundColor(.white)
            }
            Text(Caption) // displays the name of the button
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct Footer: View{
    var body: some View{
        HStack{
            Spacer() // sets spacing of 20px
                .frame(width:20)
            
            HStack{
                Spacer() // sets spacing of 40px
                    .frame(width:40)
                FooterButton(DirectTo: .Landing, ButtonSymbol: "house.fill", Caption: "Home") // displays button for Landing Page
                Spacer() // sets equal spacing between items displayed on the screen
                FooterButton(DirectTo: .Menu, ButtonSymbol: "takeoutbag.and.cup.and.straw.fill", Caption: "Menu") // displays button for Menu Page
                Spacer() // sets equal spacing between items displayed on the screen
                FooterButton(DirectTo: .Orders, ButtonSymbol: "list.bullet", Caption: "Orders") // displays button for Orders Page
                Spacer() // sets equal spacing between items displayed on the screen
                FooterButton(DirectTo: .Account, ButtonSymbol: "person.circle", Caption: "Account") // displays button for Account Page
                Spacer() // sets spacing of 40px
                    .frame(width:40)
            }
            .frame(maxWidth:.infinity)
            .frame(height: 80) // sets the box's height to 80px
            .background(.red)
            .cornerRadius(20) // sets all the corners as rounded
            
            Spacer() // sets spacing of 20px
                .frame(width:20)
        }
    }
}


func StdButton(_ text: String) -> some View { // set the StdButton(text: "") to the standard formatting of a button
        let text = Text(text) // formats text inside of the button
        .frame(width: 200, height: 50)
        .background(.red)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.white)
        .cornerRadius(10)
        
        return text
}

//landing

struct MenuStackButton: View{
    
    @EnvironmentObject var viewRouter: ViewRouter // sharing ViewRouter so that this struct has access to its data
    @EnvironmentObject var category: Categories // sharing Categories so that this struct has access to its data
    @EnvironmentObject var showcategory: showCategories // sharing showCategories so that this struct has access to its data
    var textsize: CGFloat // input of size of text
    var text: String // input of the text contents
    var image: String // input of image name
    
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
                    Spacer() // sets spacing of 10px
                        .frame(width:10)
                    VStack{
                        Spacer() // sets equal spacing between items displayed on the screen
                        Text(text)
                            .font(.system(size: textsize,weight: .semibold))
                            .foregroundColor(.black)
                        Spacer() // sets spacing of 10px
                            .frame(height: 10)
                    }
                    Spacer() // sets equal spacing between items displayed on the screen
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60,height: 60)
                    Spacer() // sets spacing of 10px
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
            Divider() //looks ugly
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
    let stock: String
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
                
                Spacer() // sets equal spacing between items displayed on the screen
                //details + add button
                VStack{
                    Text(item.name) // displays item name
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Price: £\(String(format: "%.2f", Double(item.cost)!))") // displays item cost
                    
                    Button{
                        var inBasket = false
                        for purchased in basket.currentBasket {
                            if (item.name == purchased.name) { //checks if item already in basket
                                inBasket = true
                                break
                            }
                        }
                        if (Int(item.stock)!-(item.count+1)>=0){
                            
                            if inBasket==false { // if not in basket, adds item to basket
                                item.count+=1
                                basket.currentBasket.append(item)
                                //print(basket.currentBasket)
                                basket.calculateCost() //updates basket total cost value
                                print("Added item")
                                
                            } else { // if already in basket, increase quantity by 1
                                for (pos, purchased) in basket.currentBasket.enumerated() {
                                    if purchased.name == item.name {
                                        basket.currentBasket[pos].count += 1 // adds one to the count of item in basket
                                    }
                                }
                                basket.calculateCost() //updates basket total cost value
                                print("Item quantity increased by one")
                            }
                        }else{
                            print("Insufficient Stock")
                        }
                    }label:{
                        Text("Add")
                            .frame(width: 80, height: 20)
                            .background(.red)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                    }
                }
                Spacer() // sets equal spacing between items displayed on the screen
            }
        }
    }
}

struct Order: Identifiable{
    let id: String
    let number: String
    let items: String // [Item] but not for now
    let time: Timestamp // change to NSDate() or something that is actually the time
    let code: String
    let active: String
    let user: String
    let totalCost: String
}

class Orders: ObservableObject {
    @Published var all : [Order] = []
    
    init() {
        fetchAllOrders()
    }
    
    func fetchAllOrders() {
        let db = Firestore.firestore() // links to firestore
        
        db.collection("Orders").addSnapshotListener { querySnapshot, error in //listens for changes in 'Items'
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.all = documents.map { Order(id: $0.documentID, number: "\($0["Order Number"]!)" , items: "\($0["Items"]!)", time: $0["Order Time"] as! Timestamp , code: "\($0["Order Code"]!)", active: "\($0["isActive"]!)", user: "\($0["User"]!)", totalCost: "\($0["TotalCost"]!)") // $0 is first parameter
            }
            print("Orders: \(self.all)")
        }
    }
}

struct OrderInView: View{
    var Order: Order
    var Active: String
    
    var body: some View{
        if (Order.active == Active){
            VStack(alignment: .leading){
                
                HStack{
                    Spacer() // // sets spacing of 20px
                        .frame(width:20)
                    HStack{
                        HStack{
                            Text("Order #\(String(Order.number))") // Order number displayed
                                .font(.system(size: 24, weight: .bold))
                            Spacer() // sets equal spacing between items displayed on the screen
                            
                            VStack{
                                Text(Date(timeIntervalSince1970: Double(Order.time.seconds)).formatted()) // Nicely formatted date 'MM/DD/YYYY, H:MM'
                                
                                VStack{
                                    Text(Order.items)
                                }
                                ///ForEach(Order.items){ item in
                                ///    Text(item.name)
                                ///}
                                if (Active == "Y"){
                                    Text("Order Code: \(String(Order.code))")
                                }
                            }
                            
                        }
                        
                        VStack(alignment:.leading){
                            //ForEach(Order.items){ item in
                            //  Text("\(item)")
                            //}
                        }
                    }
                    .padding()
                    .border(.black, width: 3)
                    
                    Spacer() // sets spacing of 20px
                        .frame(width:20)
                }
                
                
            }
        }
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
        HStack{ //Item placeholder
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
                
                Text("Price: £\(String(format: "%.2f", Double(item.cost)!))") // displays item cost
                
                HStack{
                    // add or remove counter
                    HStack{ 
                        Button{ // -1 count
                            if (item.count > 1) {
                                for (pos, purchased) in basket.currentBasket.enumerated() {
                                    if purchased.name == item.name {
                                        basket.currentBasket[pos].count -= 1 // adds one to the count of item in basket
                                    }
                                }
                                item.count -= 1
                                basket.calculateCost() //updates basket total cost value
                                //print(basket.currentBasket)
                                print("Removed one")
                                
                            }else if (item.count == 1){
                                item.count = 0
                                basket.currentBasket = basket.currentBasket.filter{$0.name != item.name}
                                basket.calculateCost() //updates basket total cost value
                                print("Item removed")
                                //print(basket.currentBasket)
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
                        
                        Button{ // +1 count
                            if (Int(item.stock)!-(item.count+1)>=0){
                                for (pos, purchased) in basket.currentBasket.enumerated() {
                                    if purchased.name == item.name {
                                        basket.currentBasket[pos].count += 1 // adds one to the count of item in basket
                                    }
                                }
                                item.count += 1
                                basket.calculateCost() //updates basket total cost value
                                                       //print(basket.currentBasket)
                                print("Added one")
                            }else{
                                print("Insufficient Stock")
                            }
                            
                        }label:{
                            Text("+")
                                .frame(width: 30, height: 25) 
                                .background(.green)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .cornerRadius(10,corners: [.topRight,.bottomRight])
                        }
                    }
                    
                    //Remove Item button
                    Button{
                        basket.currentBasket = basket.currentBasket.filter{$0.name != item.name}
                        basket.calculateCost() //updates basket total cost value
                        //print(basket.currentBasket)
                        print("Item Removed") // remove from basket
                        
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
                    Text("Cost: £\(String(format: "%.2f", Double(item.cost)!*Double(item.count)))")
                }
            }
        }
    }
}

//popup window
struct popupWindow: View{
    var image: String
    var text: String
    var body: some View{
        ZStack{
            Rectangle()
                .fill(.black)
                .frame(width:182,height: 182)
                .cornerRadius(5)
            
            Rectangle()
                .fill(.white)
                .frame(width:180,height: 180)
                .cornerRadius(5)
                
            VStack(alignment: .center){
                Spacer()
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120,height:120)
                Text(text)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
        }
    }
}

struct User: Identifiable{
    let id: String
    let name: String
    let password: String
    let UID: String
    let year: String
    let limit: String
    let spent: String
}

class Users: ObservableObject {
    
    @Published var all: [User] = []
    @Published var mainUser: [User] = []
    @EnvironmentObject var basket: Basket
    
    init(){
        fetchAllUsers()
        findMainUser()
    }
    
    func fetchAllUsers() {
        let db = Firestore.firestore()
        db.collection("Users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            let all = documents.map { User(id: $0.documentID, name: "\($0["Name"]!)", password: "\($0["Password"]!)", UID: "\($0["UID"]!)", year: "\($0["Year"]!)", limit: "\($0["Limit"]!)", spent: "\($0["Spent"]!)") // $0 is first parameter
            }
            print("Users: \(all)")
        }
    }
    
    func findMainUser() {
        let currentUser = Auth.auth().currentUser!.uid
        print("OK!")
        print(all)
        for user in all{
            print("Loop")
            if user.UID == currentUser {
                mainUser.append(user) //set mainUser[0]
                print(" Main User:\(mainUser)")
            }
        }
    }
    
    func checkLimit() -> Bool {
        if mainUser[0].limit == "-1"{
            return true
        } else if ((Double(mainUser[0].spent)!) + basket.totalCost <= Double(mainUser[0].limit)!){
            return true
        }
        else{
            return false
        }
    }
}

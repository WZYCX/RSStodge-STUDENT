import SwiftUI
import Firebase

struct MenuPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var allitems: AllItems
    @State var showCategories = false
    @State var Category = Categories()
    
    var body: some View{
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack{
            
                Header()
                Text("Menu")
                    .font(.system(size: 50, weight: .bold))
                
                //  dropdown menu
                HStack{
                    Spacer()
                    
                    Button{
                        withAnimation{ // animates the dropdown menu
                            showCategories.toggle()
                        }
                    }label:{
                        Image(systemName:"line.horizontal.3.decrease.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                            .foregroundColor(.red)
                    }

                    Spacer()
                        .frame(width:20)
                }
                
                if showCategories == true{
                        Dropdown().environmentObject(Category)
                }
                    
                ScrollView(showsIndicators: false) { // list of items
                    VStack(alignment:.leading) {
                    
                        ForEach(allitems.all) { product in
                            ItemToSell(item: product)
                        }.padding(10)
                        
                    }
                }
                Spacer()
                Footer()
            }
        }
    }
}

class AllItems: ObservableObject {
    
    @Published var all: [Item] = []
    
    init() {
        //fetchAllUsers() //remove at a later date
        fetchAllItems() //remove at a later date
    }
    
    func fetchAllItems() {
        let db = Firestore.firestore() // links to firestore
        
        db.collection("Items").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.all = documents.map { Item(id: $0.documentID, name: "\($0["Name"]!)" , desc: "\($0["Description"]!)", cost: "\($0["Sales Price"]!)", category: "\($0["Category"]!)", image: "\($0["Image"]!)", Count: 0) // $0 is first parameter
                
            }
            print("All: \(self.all)")
        }
    }
}

//for canvas to provide preview
struct MenuPreview: PreviewProvider {
    
    static var previews: some View {
        MenuPage()
    }
}

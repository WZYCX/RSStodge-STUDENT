import SwiftUI
import Firebase

struct MenuPage: View{
    
    @EnvironmentObject var allitems: AllItems // sharing AllItems so that this struct has access to its data
    @EnvironmentObject var showcategory: showCategories // sharing ViewRouter so that this struct has access to its data
    @State var showCategories = false // a variable to toggle whether or not the categories should be shown
    
    var body: some View{
        ZStack{
            Color.white // sets background colour to white
                .ignoresSafeArea()
            VStack{
            
                Header() // displays the page's header
                Text("Menu") // displays the page's heading
                    .font(.system(size: 50, weight: .bold))
                
                // dropdown menu
                HStack{
                    Spacer() // sets equal spacing between items displayed on the screen
                    
                    Button{
                        if showcategory.show == false {
                            withAnimation{ // animates the dropdown menu opening if not already open
                                showcategory.show.toggle()
                            }
                        } else {
                            showcategory.show.toggle() // no animation hiding
                        }
                        
                    }label:{
                        Image(systemName:"line.horizontal.3.decrease.circle") // displays a symbol as the button
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                            .foregroundColor(.red)
                    }

                    Spacer() // adds a spacing of 20px
                        .frame(width:20)
                }
                
                if showcategory.show == true{
                        Dropdown() // shows the menu of categories if .show is true
                }
                
                //items displayed
                ScrollView(showsIndicators: false) { // list of items
                    VStack(alignment:.leading) {
                    
                        ForEach(allitems.all) { product in // iterates through all the items
                            ItemToSell(item: product) //displays the item and its details in a nice format
                        }.padding(10)
                        
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
        }
    }
}

class AllItems: ObservableObject {
    
    @Published var all: [Item] = [] //creating an empty list with terms of type 'Item' and as an @published value so that all structs are updated when its value changes
    
    init() {
        fetchAllItems() // runs the function to fetch all items
    }
    
    func fetchAllItems() {
        let db = Firestore.firestore() // links to firestore
        
        db.collection("Items").addSnapshotListener { querySnapshot, error in //listens for changes in 'Items'
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.all = documents.map { Item(id: $0.documentID, name: "\($0["Name"]!)" , desc: "\($0["Description"]!)", cost: "\($0["Sales Price"]!)", category: "\($0["Category"]!)", image: "\($0["Image"]!)", count: 0) // adds in all Items as type 'Item' and their details into the 'all' list
                // debug: $0 is first parameter
                
            }
        print("All: \(self.all)") // debug - return all the items into t
            
            /// returns:
            /// [Rugby_School_Stodge_STUDENT.Item(id: "29evVAtyMn4vN6IiaUpD", name: "Harrogate Water (Still)", desc: "Still Water", cost: "0.50", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/water.webp?alt=media&token=294ae8ec-0cbf-4229-a7ac-02baeef46c46", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "OxhJ0womCFUu6O5JPWCc", name: "Walkers Crisps (Cheese and Onion)", desc: "Cheese and Onion Crisps", cost: "0.50", category: "Snacks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Cheese%20and%20Onion.png?alt=media&token=6dc5ad2d-7df4-4e0d-b87d-5306316f1979", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "QYPvJbNELMRoG3tMetTf", name: "Walkers Crisps (Salt and Vinegar)", desc: "Salt and Vinegar Crisps", cost: "0.50", category: "Snacks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Salt%20and%20Vinegar.png?alt=media&token=2e5ad30d-bb69-43aa-acdb-2a26c0a309d6", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "VXoI0oL0HwrLy9ig32Tb", name: "Chicken Burger", desc: "Hot Chicken Burger with Cheese", cost: "1.20", category: "Hot Food", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Chicken%20Burger.png?alt=media&token=e4ac0c95-0f51-4d99-a4f3-44ed300528b4", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "YTKYOGW8AQf7vzq0GNAo", name: "Appletiser", desc: "Sparkling Apple Drink", cost: "1", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Appletiser.png.webp?alt=media&token=464f5f38-7f94-4ff6-ac24-c00b413eaeb3", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "hvF31DzYkwVhyUJ36e85", name: "Walkers Crisps (Ready Salted)", desc: "Ready Salted Crisps", cost: "0.50", category: "Snacks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Walkers%20Ready%20Salted.webp?alt=media&token=194f0fd3-ec11-47c4-9bd4-54a8f0e783e7", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "uxfrLB0kPTkawtuGlC63", name: "Lucozade Sport (Orange)", desc: "Orange Flavoured Lucozade Sport Energy Drink ", cost: "1.00", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Orange%20Lucozade.jpg?alt=media&token=b4b0284e-cb1c-4041-a9f0-6b51552e3896", Count: 0), Rugby_School_Stodge_STUDENT.Item(id: "vriubKiOnapl23JmKZFv", name: "Lipton Ice Tea (Peach)", desc: "Peach Ice Tea drink", cost: "1.20", category: "Drinks", image: "https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/Peach%20Ice%20Tea.png?alt=media&token=30ee68d5-935e-4e21-8584-84ef9190d219", Count: 0)]
        }
    }
}

//for canvas to provide preview
struct MenuPreview: PreviewProvider {
    
    static var previews: some View {
        MenuPage()
    }
}

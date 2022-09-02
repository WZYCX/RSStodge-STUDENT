import SwiftUI
import Firebase

struct MenuPage: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
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
                
                //  filter/show categories button/dropdown menu
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
                    LazyVStack(alignment:.center) {
                    
                        ForEach(1...10, id: \.self) { _ in // duplicate by 10
                            ItemToSell(item: <#T##Item#>)
                        }.padding(10)
                    }
                }
                Spacer()
                Footer()
            }
        }
    }
}
                

//for canvas to provide preview
struct MenuPreview: PreviewProvider {
    
    static var previews: some View {
        MenuPage()
    }
}

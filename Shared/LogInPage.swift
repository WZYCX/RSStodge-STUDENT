import SwiftUI

struct LogInPage: View {
    
    @State public var Username: String = ""
    @State public var Password: String = ""
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            //BackgroundView(topColor: .cyan, bottomColor: .red)
            VStack {
                //Header(amountOfPadding: 100, textSize: 30, ImageSize: 80,IsLogIn: true)
                
                Text("Welcome ")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top,160)
                
                RSStodgeLogo(textSize: 30, ImageSize: 80)
                
                Text(" \(Username)")
                    .font(.system(size: 70, weight: .bold))
                    .padding(.bottom,10)
                    .multilineTextAlignment(.center)
            
                InputBox(Stuff: "Enter your User ID", matchingState: $Username, IsSecure: false)
            
                InputBox(Stuff: "Enter your Password", matchingState: $Password, IsSecure: true)
                
                Button{
                    print("Link to next page")
                    withAnimation {
                        viewRouter.currentPage = .Landing
                    }

                }label: {
                    Text("Confirm")
                        .frame(width: 200, height: 50)
                        .background(.red)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            
                Spacer()
            }
        }
    }
}
//to complete
/*
var ExistingUsers = [[String]]()
var temp = [String]()
temp.append("1234")
temp.append("Chen")
ExistingUsers.append(temp)
func verifyLogIn(User:String,Pass:String){
    
}
 */
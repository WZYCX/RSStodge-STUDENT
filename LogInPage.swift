import SwiftUI
import Firebase

struct LogInPage: View {
    
    //@State private var UserID: String = ""
    @State private var Email: String = ""
    @State private var Password: String = ""
    @State var Loginfail = false
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            //BackgroundView(topColor: .cyan, bottomColor: .red)
            VStack {
                
                Text("Welcome ")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top,160)
                
                RSStodgeLogo(textSize: 30, ImageSize: 120)
                    .padding(.bottom,50) // to replace text this from below
                
                /*
                Text(" \(UserID)")
                    .font(.system(size: 70, weight: .bold))
                    .padding(.bottom,10)
                    .multilineTextAlignment(.center)
                 
                //InputBox(Stuff: "Enter your User ID", matchingState: $UserID, IsSecure: false)
                 */
                 
                InputBox(Stuff: "Enter your Email", matchingState: $Email, IsSecure: false)
                    .onSubmit {
                        print("Authenticating")
                        LogIn()
                    }
                
                InputBox(Stuff: "Enter your Password", matchingState: $Password, IsSecure: true)
                    .onSubmit {
                        print("Authenticating")
                        LogIn()
                    }
                
                Button{
                    LogIn()
                }label: {
                    StdButton("Confirm")
                }
                
                //switches to landing page if user is logged in
                .onAppear {Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        print("Logging in...")
                        withAnimation {
                            viewRouter.currentPage = .Landing
                        }
                    } else {
                        withAnimation {
                            viewRouter.currentPage = .LogIn
                        }
                    }
                }
                }
            
                if Loginfail == true{
                    Text("Username/Password is incorrect")
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }
    }
    
    func LogIn() {
        Auth.auth().signIn(withEmail: Email, password: Password) { result, error in
            if error != nil{
                Loginfail = true
                print(error!.localizedDescription)
            }
        }
    }
}

//for canvas to provide preview
struct LogInPreview: PreviewProvider {
    
    static var previews: some View {
        LogInPage()
    }
}

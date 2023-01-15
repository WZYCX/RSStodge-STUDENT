import SwiftUI //importing library for GUI features
import Firebase //importing library to communicate with Firebase Database

struct LogInPage: View {

    @State private var Email: String = "" // setting up a private (can only be accessed within the struct) variable to store inputted Email
    @State private var Password: String = "" // setting up a private (can only be accessed within the struct) variable to store inputted Password
    @State var Loginfail = false // toggles to true if login fails for error message
    @EnvironmentObject var viewRouter: ViewRouter // sharing ViewRouter so that this struct has access to its data.
    @State var showForgot = false // toggles to true to show Forgotten Details page
    
    var body: some View { // main body that contains all that is displayed on screen
        ZStack{
            Color.white //sets background colour to white
                .ignoresSafeArea() //does not create a 'safety' border around the edges
            VStack {
                Text("Welcome ") // displays string on the app
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top,160)
                
                RSStodgeLogo(textSize: 30, ImageSize: 120) // Shows the RSStodgeLogo view
                    .padding(.bottom,50)
                
                 
                InputBox(Stuff: "Enter your Email", matchingState: $Email, IsSecure: false) // A box displayed that takes an input of User's email
                    .onSubmit { // when enter is clicked
                        print("Authenticating") // debug - outputs to console if running
                        LogIn() // Runs the function to check inputted detailsif they are in the database
                    }
                
                InputBox(Stuff: "Enter your Password", matchingState: $Password, IsSecure: true)  // A box displayed that takes an input of User's password in a secure text box
                    .onSubmit { // when enter is clicked
                        print("Authenticating")  // debug - outputs to console if running
                        LogIn() // Runs the function to check inputted details if they are in the database
                    }
                
                Button{ // Forgotten Details popover
                    showForgot.toggle()
                }label: {
                    Text("Forgot Details?")
                }
                
                Button{ // displays button that checks for successful login
                    LogIn()
                }label: {
                    StdButton("Confirm") // displays red button
                }
                
                //switches to landing page if user is logged in
                .onAppear {Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil { //if there is already a user whose details have been authenticated redirect to landing page
                        print("Logging in...")
                        withAnimation {
                            viewRouter.currentPage = .Landing // redirects to Landing page if the user is validated
                        }
                    } else {
                        withAnimation {
                            viewRouter.currentPage = .LogIn // redirects to Login page if the user is validated
                        }
                    }
                }
                }
            
                if (emailCheck(email: Email) == false || Loginfail == true) {
                    Text("Username/Password is incorrect") // If the login details are incorrect,
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }
        .popover(isPresented: $showForgot) {
           forgotDetails().colorScheme(.light)
        }
    }
    
    func emailCheck(email:String) -> Bool{ // regex check to sanitise email input
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
    }
    
    func LogIn() {
        Auth.auth().signIn(withEmail: Email, password: Password) { result, error in // checks if the database contains the user's details
            if error != nil{
                Loginfail = true // toggles the text displayed if the user details are incorrect
                print(error!.localizedDescription) // debug - return to console the error from firebase if details are incorrect
            }
        }
    }
}

struct forgotDetails: View{
    
    @Environment(\.presentationMode) var presentationMode // sets the variable presentationMode to the view
    @State private var Email : String = ""
    @State private var Message : String = " "
    
    var body: some View{
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            VStack{
                Text("Forgotten Details")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top,20)
                
                Spacer()
                
                Text("A email will be sent to your inbox to reset your password:")
                    .font(.system(size: 14, weight: .regular))
                
                InputBox(Stuff: "Enter your Email", matchingState: $Email, IsSecure: false) // A box displayed that takes an input of User's email
                    .padding(.bottom,40)
                
                Text(Message)
                    .foregroundColor(.red)
                
                Button{
                    if (emailCheck(email: Email) == true) { // if the email is incorrect
                        sendResetEmail(email: Email) // Runs the function to send reset email
                        Message = "Email Sent!"
                    } else{
                        Message = "Invalid Email"
                    }
                    
                } label: {
                    StdButton("Send Email")
                    
                }
                Spacer()
            }
        }
    }
    func sendResetEmail(email:String) {
        print("Sending Email...")
        Auth.auth().sendPasswordReset(withEmail: email) // sends email to inputted address
    }
    func emailCheck(email:String) -> Bool{ // regex check to sanitise email input
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: email)
    }
}

//for canvas to provide preview
struct LogInPreview: PreviewProvider {
    
    static var previews: some View {
        LogInPage()
    }
}

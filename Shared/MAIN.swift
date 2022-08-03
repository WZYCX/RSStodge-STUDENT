import SwiftUI
import Firebase


@main
struct Stodge: App {
    
    @StateObject var viewRouter = ViewRouter()
    @StateObject var firestoreManager = FirestoreManager() //allows FirestoreManager to be accessed by app
    
    //firebase stuff
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .environmentObject(viewRouter)
            
                .ignoresSafeArea() // the home bar is causing 'safe area' below footer bar
                .environmentObject(firestoreManager) //sets it as an environment object to be accessed by app
        }
    }
    

}

//for canvas to provide preview
struct LibraryViewPreview: PreviewProvider {
    
    static var previews: some View {
        LogInPage()
    }
}

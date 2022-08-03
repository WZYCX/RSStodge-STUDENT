import SwiftUI
import Firebase


@main
struct Stodge: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    //firebase stuff
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
                .ignoresSafeArea() // the home bar is causing 'safe area' below footer bar
        }
    }
    

}

//for canvas to provide preview
struct LibraryViewPreview: PreviewProvider {
    
    static var previews: some View {
        LogInPage()
    }
}

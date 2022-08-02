import SwiftUI

//firebase stuff
import Firebase


@main
struct Stodge: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
                .ignoresSafeArea() // the home bar is causing 'safe area' below footer bar
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}

//for canvas to provide preview
struct LibraryViewPreview: PreviewProvider {
    
    static var previews: some View {
        LogInPage()
    }
}

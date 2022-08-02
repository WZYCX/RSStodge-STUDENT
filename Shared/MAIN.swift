import SwiftUI

//firebase stuff
import Firebase


@main
struct Stodge: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(viewRouter)
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}

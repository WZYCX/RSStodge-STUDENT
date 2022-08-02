import SwiftUI

struct Loading: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View{
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack{
                RSStodgeLogo(textSize: 30, ImageSize: 80)
            }
        }
    }
}

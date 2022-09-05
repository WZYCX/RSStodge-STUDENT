import SwiftUI

struct SplashPage: View{
    
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

struct LogoPage: View{
    
    var body: some View{
        ZStack{
            Color.red
                .ignoresSafeArea()
            VStack{
                Image("newRSLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400)
            }
        }
    }
}

struct BurgerPage: View{
    
    var body: some View{
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack{
                Image("RedBurger")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                    .foregroundColor(.red)
            }
        }
    }
}

struct DrinkPage: View{
    var body: some View{
        ZStack{
            Color.red
                .ignoresSafeArea()
            VStack{
                Image("Fizzydrink")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
            }
        }
    }
}

struct SplashPreview: PreviewProvider {
    
    static var previews: some View {
        //SplashPage()
        LogoPage()
        //BurgerPage()
        //DrinkPage()
    }
}

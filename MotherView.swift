import SwiftUI //importing library for GUI features

enum Page { // creating the possible values for Page
    case LogIn
    case Landing
    case Menu
    case Account
    case Orders
    case Basket
}


class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .LogIn //setting the original value of currentPage and as an @published value so that all structs are updated when its value changes
    
}


struct MotherView: View{
    
    @EnvironmentObject var viewRouter: ViewRouter // sharing ViewRouter so that this struct has access to its data.
    
    var body: some View {
        switch viewRouter.currentPage { // displays a certain page depending on the value of currentPage
        case .LogIn:
            LogInPage().colorScheme(.light)
        case .Landing:
            LandingPage().colorScheme(.light)
        case .Menu:
            MenuPage().colorScheme(.light)
        case .Account:
            AccountPage().colorScheme(.light)
        case .Orders:
            OrdersPage().colorScheme(.light)
        case .Basket:
            BasketPage().colorScheme(.light)
        }
    }
}

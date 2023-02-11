import SwiftUI

struct AccountPage: View{
    
    @EnvironmentObject var user: Users // sharing Users so that this struct has access to its data
    
    var body: some View{
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack{
                Header()
                Text("Account") // title
                    .font(.system(size: 50, weight: .bold))
                Spacer()
                UserDetails(ProfileImage: user.mainUser[0].profilepic , Name: user.mainUser[0].id, Year: user.mainUser[0].year, StodgeID: user.mainUser[0].code) // displays user details
                Spacer()
                    .frame(height:50)
                Spacer()
            }

            VStack{
                Spacer() // sets equal spacing between items displayed on the screen
                Footer() // displays the page's footer
                Spacer()
                    .frame(height: 40)
            }
        }
    }
}

import SwiftUI

struct AccountPage: View{
    
    var body: some View{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack{
                    Header()
                    Text("Account")
                        .font(.system(size: 50, weight: .bold))
                        .padding(40)
                    Spacer()
                    UserDetails(ProfileImage: "WCProfilePic", Name: "William Chen", Year: "LXX", StodgeID: "1234")
                    Spacer()
                    Footer()
                }
        }
    }
}

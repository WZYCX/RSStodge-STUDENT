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
                    Spacer()
                    UserDetails(ProfileImage:"https://firebasestorage.googleapis.com/v0/b/rs-stodge-student.appspot.com/o/WCProfilePic.jpg?alt=media&token=697be2b3-5b9c-4f9d-b248-77bbba9dd775", Name: "William Chen", Year: "LXX", StodgeID: "1234")
                    Spacer()
                    Footer()
                }
        }
    }
}

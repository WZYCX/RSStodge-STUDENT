//
//  SplashPage.swift
//  Rugby School Stodge STUDENT
//
//  Created by William Chen on 16/01/2023.
//

import SwiftUI
import Firebase

struct SplashPage: View {
    
    @EnvironmentObject var viewRouter: ViewRouter // sharing ViewRouter so that this struct has access to its data.
    
    var body: some View {
        ZStack{
            Color.red // sets background colour to red
                .ignoresSafeArea()
            VStack{
                Spacer()
                    Image("newRSLogo") // displays image
                Spacer()
            }
        }
        //switches to landing page if user is logged in
        .onAppear {Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Async after 2 seconds")
                if user != nil { //if there is already a user whose details have been authenticated redirect to landing page
                    print("Logging in...")
                    withAnimation {
                        viewRouter.currentPage = .Landing // redirects to Landing page if the user is validated
                    }
                } else {
                    withAnimation {
                        viewRouter.currentPage = .LogIn // redirects to Login page if the user is validated
                    }
                }
            }
        }
        }
    }
}

struct SplashPage_Previews: PreviewProvider {
    static var previews: some View {
        SplashPage()
    }
}

import SwiftUI

struct LandingPage: View{
    
    var body: some View{
            ZStack{
                Color.white // sets background colour to white
                    .ignoresSafeArea()
                VStack{
                    Header() // displays the page's header
                    
                    ScrollView(showsIndicators: false){ // the area of the screen is scrollable
                        
                        VStack(alignment:.leading){
                            Text("Hi \nWilliam") //placeholder for "Hi \n\(name)"
                                .frame(width: 300, height: 150, alignment: .leading)
                                .font(.system(size: 50, weight: .semibold))
                        }
                        
                        MenuStack() // displays the four buttons to quickly navigate to a certain Menu category
                        
                        VStack{
                            Text("News") // displays the page heading
                                .font(.system(size: 60, weight: .semibold))
                            
                            NewsBox(stories: [["Title1","Body1"] ,
                                              ["Title2","Body2"] ,
                                              ["Title3","Body3"] ,
                                              ["Title4","Body4"]]) // displays all the news stories formatted
                        }
                    }
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

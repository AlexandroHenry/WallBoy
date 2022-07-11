//
//  SideMenu.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/07/11.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct SideMenu: View {
    
    @AppStorage("log_Status") var log_Status = true
    
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 14) {
                Image("sample_profile3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                
                Text("지호넘이쁘")
                    .font(.title2.bold())
                
                Text("@지호짱이뻐")
                    .font(.callout)
                
                HStack(spacing: 12) {
                    
                    Button {
                        
                    } label: {
                        
                        Label {
                            Text("Followers")
                        } icon: {
                            Text("189")
                                .fontWeight(.bold)
                        }
                    }
                    
                    
                    Button {
                        
                    } label: {
                        
                        Label {
                            Text("Following")
                        } icon: {
                            Text("1.2M")
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                .foregroundColor(.primary)
                 
            }
            .padding(.horizontal)
            .padding(.leading)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    VStack(alignment: .leading, spacing: 35) {
                        
                        // Tab Buttons...
                        TabButton(title: "Profile", image: "person.circle")
                            .foregroundColor(.black)
                        
                        TabButton(title: "Portfolio", image: "bag")
                            .foregroundColor(.blue)
                        
                        TabButton(title: "Favorite", image: "heart.fill")
                            .foregroundColor(.pink)
                        
                        TabButton(title: "News", image: "globe")
                            .foregroundColor(.green)
                        
                        TabButton(title: "My Record", image: "dollarsign.circle")
                            .foregroundColor(.yellow)
                        
                        
                    }
                    .padding()
                    .padding(.leading)
                    .padding(.top, 35)
                    .padding(.bottom)
                    
                    Divider()
                    
                    TabButton(title: "Setting & Privacy", image: "gear")
                        .foregroundColor(.gray)
                        .padding()
                        .padding(.leading)
                    
                    TabButton(title: "Help Center", image: "questionmark.circle")
                        .padding()
                        .padding(.leading)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        Button {
                            
                            GIDSignIn.sharedInstance.signOut()
                            try? Auth.auth().signOut()

                            withAnimation{
                                log_Status = false
                            }
                            
                        } label: {
                            Image(systemName: "power.circle")
                                .padding(.trailing)
                                .foregroundColor(.red)
                            Text("Logout")
                        }

                        
                    }
                    .padding()
                    .padding(.leading)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                    
                    
                }
                
            }
            
            
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        // Max Width...
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.04)
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    @ViewBuilder
    func TabButton(title: String, image: String) -> some View {
        
        // For navigation...
        // Simple replace button with Navigation Links...
        
        
        NavigationLink {
            
            Text("\(title) View")
                .navigationTitle(title)
            
        } label: {
            
            HStack(spacing: 13) {
                
                Image(systemName: image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                
                Text(title)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
        }
    }
    
    
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Extending view to get Screen Rect...

extension View{
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

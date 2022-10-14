//
//  SideMenu.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct SideMenu: View {
    
    @Binding var showMenu: Bool
    @AppStorage("userID") var userID = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("log_Status") var log_Status = true
    @StateObject var googleLoginVM = GoogleLoginViewModel()
    @StateObject var myInfoVM = MyInfoViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 15) {
                
                HStack {
                    Button{
                        withAnimation {
                            showMenu.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("뒤로")
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // MARK: 언어변경
                    Button {
                        isEnglish.toggle()
                    } label: {
                        HStack {
                            if isEnglish {
                                Image("flag_us")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 15, height: 15)
                                    .padding(.trailing, 10)
                                Text("English")
                            } else {
                                Image("flag_korea")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 15, height: 15)
                                    .padding(.trailing, 10)
                                Text("한국어")
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    
                }
                .padding(.bottom)
                
                NavigationLink {
                    ChangePhotoView()
                } label: {
                    AsyncImage(url: URL(string: myInfoVM.userInfo.result.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(myInfoVM.userInfo.result.nickname)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text(myInfoVM.userInfo.result.email)
                    .font(.callout)
                    .foregroundColor(.primary)
                
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
            .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    VStack(alignment: .leading, spacing: 35) {
                        
                        // Tab Buttons ...
//                        TabButton(title: "Test", image: "camera")
//                        TabButton(title: "Test2", image: "camera")
//                        TabButton(title: "Indices", image: "bag")
                        TabButton(title: "Futures", image: "camera.macro")
                        
                        TabButton(title: "Indices", image: "chart.line.uptrend.xyaxis")
                        TabButton(title: "Profile", image: "person")
                        TabButton(title: "Portfolio", image: "bag")
                        TabButton(title: "News", image: "globe")
                        TabButton(title: "Setting", image: "gear")
                        TabButton(title: "Help", image: "questionmark.circle")
                        
                    }
                    .padding()
                    .padding(.leading)
                    .padding(.top, 10)
                    
                    Divider()
                    
                    TabButton(title: "Twitter Ads", image: "qrcode")
                        .padding()
                        .padding(.leading)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Button("Settings And Privacy") {
                            
                        }
                        
                        Button("Help Center") {
                            
                        }
                        
                    }
                    .padding()
                    .padding(.leading)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                    
                }
            }
            .padding(.bottom, 5)
            
            VStack(spacing: 0) {
                Divider()
                
                HStack {
                    
                    Button {
                        GIDSignIn.sharedInstance.signOut()
                        try? Auth.auth().signOut()
                        
                        withAnimation{
                            log_Status = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "power.circle")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 22, height: 22)
                                .foregroundColor(.red)
                            
                            Text("Logout")
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "lightbulb.circle")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 22, height: 22)
                                .foregroundColor(.primary)
                            
                            if isDarkMode {
                                Text("Light Mode")
                            } else {
                                Text("Dark Mode")
                            }
                            
                        }
                    }
                    
                }
                .padding([.horizontal, .top], 15)
                .foregroundColor(.primary)
            }
            
        }
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(
            Color.primary
                .opacity(0.04)
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            print(userID)
            myInfoVM.fetchUserInfo(userId: userID)
        }
    }
    
    @ViewBuilder
    func TabButton(title: String, image: String) -> some View {
        
        NavigationLink {
            
            if title == "Test" {
                TestView()
            } else if title == "Indices" {
                IndicesView()
            } else if title == "Futures" {
                FuturesView()
            }
            else {
                Text("\(title) View")
                    .navigationTitle(title)
            }
            
            
//            // 뷰 연결 해주기
//            Text("\(title) View")
//                .navigationTitle(title)
        
        } label: {
            HStack(spacing: 14) {
                Image(systemName: image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 22, height: 22)
                
                Text(title)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

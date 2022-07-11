//
//  LoginView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/07/11.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    
    @State var isLoading: Bool = false
    
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        VStack {

            Image("LogoText_1")
            Image("LogoImage_2")
                .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                
                Button {
                    handleLogin()
                } label : {
                    
                    HStack(spacing: 15) {
                        
                        Image("google_login")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                        
                        Text("구글로 로그인 하기")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .kerning(1.1)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Capsule()
                            .stroke(Color.blue, lineWidth: 2)
                    )
                }
                
                Button {
                    
                } label: {
                    HStack(spacing: 15) {
                        
                        Image(systemName: "envelope")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .foregroundColor(.black)
                            
                        
                        Text("계정으로 로그인")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .kerning(1.1)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Capsule()
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    
                }
                
            }
            .padding()
            
            
            Text(getAttributedString(string:"By creating an account, you are agreeing to our Terms of Service"))
                .font(.body.bold())
                .foregroundColor(.gray)
                .kerning(1.1)
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay(
        
            ZStack {
                
                if isLoading {
                    Color.black
                        .opacity(0.25)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
            }
        
        )
    }
    
    
    func getAttributedString(string: String) -> AttributedString {
        
        var attributedString = AttributedString(string)
        
        if let range = attributedString.range(of: "Terms of Service") {
            
            attributedString[range].foregroundColor = .black
            attributedString[range].font = .body.bold()
        }
        
        return attributedString
    }
    
    
    func handleLogin() {
        // GoogleSign In
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {[self] user, err in
            
            if let error = err {
                isLoading = false
                print(error.localizedDescription)
              return
            }

            guard
              let authentication = user?.authentication,
              let idToken = authentication.idToken
            else {
                isLoading = false
              return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // Firebase Auth ...
            Auth.auth().signIn(with: credential) { result, err in
                
                isLoading = false
                
                if let error = err {
                    print(error.localizedDescription)
                  return
                }
                
                // Displaying User Name...
                guard let user = result?.user else {
                    return
                }
                
                print(user.displayName ?? "Success!")
                
                // Updating User as Logged in
                withAnimation{
                    log_Status = true
                }
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    // Retreiving RootView Controller...
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

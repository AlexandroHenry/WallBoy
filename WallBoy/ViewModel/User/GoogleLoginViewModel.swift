//
//  GoogleLoginViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI

class GoogleLoginViewModel: ObservableObject {
    @AppStorage("log_Status") var log_Status = false
    @AppStorage("userID") var userID = ""
    
    @Published var isLoading = false
    
    func handleLogin() {
        // GoogleSign In
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        
        print("clientID : \(clientID)")

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        print("config: \(config)")
        
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
            Auth.auth().signIn(with: credential) { [self] result, err in
                
                self.isLoading = false
                
                if let error = err {
                    print(error.localizedDescription)
                  return
                }
                
                // Displaying User Name...
                guard let user = result?.user else {
                    return
                }
                
                self.userID = user.uid
                
                let urlString = "http://131.186.28.79/userInfo/id=\(user.uid)&email=\(user.email!)"

                var request = URLRequest(url: URL(string: urlString)!)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data,
                        let response = response as? HTTPURLResponse,
                        error == nil else {                                              // check for fundamental networking error
                        print("error", error ?? "Unknown error")
                        return
                    }

                    guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                        print("statusCode should be 2xx, but is \(response.statusCode)")
                        print("response = \(response)")
                        return
                    }

                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString ?? "")")
                }

                task.resume()

                print(user.displayName ?? "Success!")
                
                withAnimation{
                    self.log_Status = true
                }
                
            }
        }
    }
    
}

extension GoogleLoginViewModel {
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

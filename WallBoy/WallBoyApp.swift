//
//  WallBoyApp.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/07/11.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct WallBoyApp: App {
    // Connecting App Delegate...
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil ) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

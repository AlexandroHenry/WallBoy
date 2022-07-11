//
//  ContentView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/07/11.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        if log_Status {
            
            BaseView()
            
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

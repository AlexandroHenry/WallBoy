//
//  LoginPageView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI

struct LoginPageView: View {
    
    @StateObject var googleLoginVM = GoogleLoginViewModel()
    
    @State var isLoading: Bool = false
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        VStack {
            
            Button {
                googleLoginVM.handleLogin()
            } label: {
                HStack {
                    Image("google_btn")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                    Text("Google 로그인")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    Spacer()
                }
            }
            .padding()
            .frame(width: 350, height: 50)
            .background(.orange)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            
        }
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}

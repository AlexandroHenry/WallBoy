//
//  Home.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/07/12.
//

import SwiftUI

struct Home: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        
        VStack {
            
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Button {
                        withAnimation{showMenu.toggle()}
                    } label: {
                        Image("sample_profile3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                        
                    }
                    
                    Spacer()
                    
                    // Navigation Link...
                    NavigationLink {
                        
                        Text("Timeline View")
                            .navigationTitle("Timeline")
                        
                    } label: {
                        
                        Image(systemName: "calendar")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(.primary)
                        
                    }
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                
                Divider()
            }
            .overlay(
                Image("LogoText_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            )
            
            Spacer()
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

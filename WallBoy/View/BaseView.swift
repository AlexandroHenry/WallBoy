//
//  BaseView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI

struct BaseView: View {
    @State var showMenu: Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State var currentTab = "Home"
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        let sideBarWidth = getRect().width - 90
        
        NavigationView {
            HStack(spacing: 0) {
                SideMenu(showMenu: $showMenu)
                
                VStack(spacing: 0) {
                    TabView(selection: $currentTab) {
                        HomeView(showMenu: $showMenu)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("Home")
                        
                        NewsView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("News")
                        
                        SearchView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("Search")
                        
                        MyAssetView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("MyAsset")
                        
                        MyInfoView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("MyInfo")
                        
                    }
                    
                    VStack(spacing: 0) {

                        HStack(spacing: 0) {
                            
                            // TabButton
                            TabButton(image: "house", name: "Home")
                            
                            TabButton(image: "globe", name: "News")
                            
                            TabButton(image: "magnifyingglass", name: "Search")
                            
                            TabButton(image: "creditcard", name: "MyAsset")
                            
                            TabButton(image: "person", name: "MyInfo")
                        }
                        .padding([.top], 15)
                    }
                }
                .frame(width: getRect().width)
                // BG when menu is showing...
                .overlay(
                    Rectangle()
                        .fill(
                            Color.primary
                                .opacity(Double((offset / sideBarWidth) / 5))
                        )
                        .ignoresSafeArea(.container, edges: .vertical)
                        .onTapGesture {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }
                )
            }
            // max Size...
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset > 0 ? offset : 0)
            // No Nav Bar title...
            // Hiding nav bar...
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .animation(.easeOut, value: offset == 0)
        .onChange(of: showMenu) { newValue in
            
            if showMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: gestureOffset) { newValue in
            onChange()
        }
    }
    
    func onChange() {
        let sideBarWidth = getRect().width - 90
        
        offset = (gestureOffset != 0) ? (gestureOffset + lastStoredOffset < sideBarWidth ? gestureOffset + lastStoredOffset : offset) : offset
    }
                
    func onEnd(value: DragGesture.Value) {
        let sideBarWidth = getRect().width - 90
        
        let translation = value.translation.width
        
        withAnimation {
            // Checking...
            
            if translation > 0 {
                
                if translation > (sideBarWidth / 2) {
                    
                    // showing menu...
                    offset = sideBarWidth
                    showMenu = true
                } else {
                    
                    // Extra cases...
                    if offset == sideBarWidth {
                        return
                    }
                    
                    offset = 0
                    showMenu = false
                }
            } else {
                 
                if -translation > (sideBarWidth / 2) {
                    offset = 0
                    showMenu = false
                } else {
                    
                    // Extra case if drag vertically
                    if offset == 0 || !showMenu {
                        return
                    }
                    
                    offset = sideBarWidth
                    showMenu = true
                }
            }
        }
        // storing last offset...
        lastStoredOffset = offset
    }
    
    @ViewBuilder
    func TabButton(image: String, name: String) -> some View {
        Button{
            withAnimation {
                currentTab = name
            }
        } label: {
            VStack {
                Image(systemName: image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 23, height: 22)
                    .foregroundColor(currentTab == name ? .green : .gray)
                    .frame(maxWidth: .infinity)
                
                Text(name)
                    .font(.footnote)
                    .foregroundColor(currentTab == name ? .green : .gray)
            }
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}

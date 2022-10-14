//
//  MarketSectorView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/27.
//

import SwiftUI

struct MarketSectorView: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Sector")
                            .font(.largeTitle.bold())
                        
                        Spacer()
                    }
                    
                    HStack {
                        SectorNavigator(type: "sector", name: "technology", imagename: "Technology", textname: "Technology")
                        SectorNavigator(type: "sector", name: "CommunicationServices", imagename: "CommunicationServices", textname: "Communication Services")
                    }
                    
                    HStack {
                        SectorNavigator(type: "sector", name: "healthcare", imagename: "CommunicationServices", textname: "Communication Services")
                        SectorNavigator(type: "sector", name: "Consumer Defensive", imagename: "ConsumerDefensive", textname: "Communication Services")
                    }
                    
                    HStack {
                        SectorNavigator(type: "sector", name: "CommunicationServices", imagename: "CommunicationServices", textname: "Communication Services")
                        SectorNavigator(type: "sector", name: "CommunicationServices", imagename: "CommunicationServices", textname: "Communication Services")
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func SectorNavigator(type: String, name: String, imagename: String, textname: String) -> some View {
        
        NavigationLink {
            MarketDetail(type: type, name: name)
        } label: {
            ZStack {
                VStack {
                    Image(imagename)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 170, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(textname)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
        
    }
}

struct MarketSectorView_Previews: PreviewProvider {
    static var previews: some View {
        MarketSectorView()
    }
}

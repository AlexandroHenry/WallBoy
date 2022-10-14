//
//  FuturesView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/05.
//

import SwiftUI

struct FuturesView: View {
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                
                HStack {
                    if isEnglish {
                        Text("Futures")
                    }else {
                        Text("선물시장")
                    }
                    Spacer()
                }
                .font(.largeTitle.bold())
                
                
                NavigationLink {
                    EnergyFuturesView()
                } label: {
                    ZStack {
                        Image("Energy")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                        Text("Energy")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .offset(y: UIScreen.screenHeight * 0.065)
                            .offset(x: UIScreen.screenWidth * 0.28)
                            .shadow(radius: 30)
                    }
                }
                .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.2)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                NavigationLink {
                    MetalFuturesView()
                } label: {
                    ZStack {
                        Image("Metal")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                        Text("Metal")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .offset(y: UIScreen.screenHeight * 0.065)
                            .offset(x: UIScreen.screenWidth * 0.28)
                            .shadow(radius: 30)
                    }
                }
                .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.2)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                HStack {
                    NavigationLink {
                        GrainFuturesView()
                    } label: {
                        ZStack {
                            AsyncImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn76ojD4ztfGepCA5XFeKBUHOKjtnnPK4OMw&usqp=CAU")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text("Grain")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .offset(y: UIScreen.screenHeight * 0.065)
                                .offset(x: UIScreen.screenWidth * 0.1)
                                .shadow(radius: 30)
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.44, height: UIScreen.screenHeight * 0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    
                    NavigationLink {
                        SoftFuturesView()
                    } label: {
                        ZStack {
                            AsyncImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvqp2WKvcuwd5b0MzGFb6bGVsdObPqT5jABRMxYwIY0CmRcBwrQzUTWxdOfk_Tsso7HUY&usqp=CAU")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text("Soft")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .offset(y: UIScreen.screenHeight * 0.065)
                                .offset(x: UIScreen.screenWidth * 0.1)
                                .shadow(radius: 30)
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.44, height: UIScreen.screenHeight * 0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }
                
                
                NavigationLink {
                    LivestockFuturesView()
                } label: {
                    ZStack {
                        AsyncImage(url: URL(string: "https://lirp.cdn-website.com/24aa6633/dms3rep/multi/opt/livestock+insurance-1920w.jpeg")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text("Livestocks")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .offset(y: UIScreen.screenHeight * 0.065)
                            .offset(x: UIScreen.screenWidth * 0.24)
                            .shadow(radius: 30)
                    }
                }
                .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.2)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
               
                
            }
            .padding()
        }
    }
}

struct FuturesView_Previews: PreviewProvider {
    static var previews: some View {
        FuturesView()
    }
}

struct EnergyFuturesView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Group {
                    HStack {
                        Text("Energy")
                        Spacer()
                    }
                    .font(.largeTitle.bold())
                    
                    LargeFuturesButtonView(symbol: "CL=F")
                    
                    HStack {
                        Spacer()
                        MediumFuturesButtonView(symbol: "BZ=F")
                        Spacer()
                        MediumFuturesButtonView(symbol: "RB=F")
                        Spacer()
                    }
                    
                    SmallFuturesButtonView(symbol: "NG=F")
                    SmallFuturesButtonView(symbol: "HO=F")
                }
            }
            .padding()
        }
    }
}

struct MetalFuturesView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Group {
                    HStack {
                        Text("Metal")
                        Spacer()
                    }
                    .padding(.top, 10)
                    .font(.largeTitle.bold())
                    
                    LargeFuturesButtonView(symbol: "GC=F")
                    
                    HStack {
                        Spacer()
                        MediumFuturesButtonView(symbol: "SI=F")
                        Spacer()
                        MediumFuturesButtonView(symbol: "HG=F")
                        Spacer()
                    }
                    
                    SmallFuturesButtonView(symbol: "PL=F")
                    SmallFuturesButtonView(symbol: "PA=F")
                    SmallFuturesButtonView(symbol: "ALI=F")
                }
            }
            .padding()
        }
    }
}

struct GrainFuturesView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Group {
                    HStack {
                        Text("Grain")
                        Spacer()
                    }
                    .padding(.top, 10)
                    .font(.largeTitle.bold())
                    
                    SmallFuturesButtonView(symbol: "ZC=F")
                    SmallFuturesButtonView(symbol: "ZW=F")
                    SmallFuturesButtonView(symbol: "ZO=F")
                    SmallFuturesButtonView(symbol: "ZR=F")
                    SmallFuturesButtonView(symbol: "ZS=F")
                    SmallFuturesButtonView(symbol: "ZM=F")
                    SmallFuturesButtonView(symbol: "ZL=F")
                }
            }
            .padding()
        }
    }
}

struct SoftFuturesView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Group {
                    HStack {
                        Text("Soft")
                        Spacer()
                    }
                    .padding(.top, 10)
                    .font(.largeTitle.bold())
                    
                    SmallFuturesButtonView(symbol: "CC=F")
                    SmallFuturesButtonView(symbol: "KC=F")
                    SmallFuturesButtonView(symbol: "SB=F")
                    SmallFuturesButtonView(symbol: "OJ=F")
                    SmallFuturesButtonView(symbol: "CT=F")
                    SmallFuturesButtonView(symbol: "LBS=F")
                    SmallFuturesButtonView(symbol: "CU=F")
                }
            }
            .padding()
        }
    }
}

struct LivestockFuturesView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Group {
                    HStack {
                        Text("Livestock")
                        Spacer()
                    }
                    .padding(.top, 10)
                    .font(.largeTitle.bold())
                    
                    LargeFuturesButtonView(symbol: "LE=F")
                    LargeFuturesButtonView(symbol: "GF=F")
                    LargeFuturesButtonView(symbol: "HE=F")
                }
            }
            .padding()
        }
    }
}

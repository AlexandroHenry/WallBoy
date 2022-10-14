//
//  HomeView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI
import Firebase
import GoogleSignIn
import Charts

struct HomeView: View {
    @Binding var showMenu: Bool
    @AppStorage("log_Status") var log_Status = false
    @AppStorage("userID") var userID = ""
    
    @State var sidebarOffsetX: CGFloat = -(UIScreen.screenWidth - 90)
    
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @StateObject var mystockcurrentpriceVM = MyStockCurrentPriceViewModel()
    @StateObject var ownStockVM = OwnStockViewModel()
    @StateObject var futuresVM = FuturesViewModel()
    
    var body: some View {
        VStack {
            // MARK: Header
            VStack(spacing: 0) {
                
                HStack {
                    Button {
                        withAnimation {
                            showMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        StockTransactionCalendarView()
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            
            ScrollView {
                SmallFuturesButtonView(symbol: "^DJI")
                SmallFuturesButtonView(symbol: "^IXIC")
                SmallFuturesButtonView(symbol: "^GSPC")
                SmallFuturesButtonView(symbol: "^KS11")
                VStack{
                    // MARK: S&P500 Button
                    VStack(spacing: 10) {
                        HStack {
                            Text("S&P 500")
                                .font(.largeTitle.bold())
                                .foregroundColor(.primary)
                            Spacer()
                        }

                        NavigationLink {
                            SP500View()
                        } label: {
                            ZStack {
                                Image("sp500_logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 220)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .background(.orange)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // MARK: MARKET
                    VStack(spacing: 10) {
                        HStack {
                            Text("Market")
                                .font(.largeTitle.bold())
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        HStack {
                            NavigationLink {
                                MarketDetail(type: "market", name: "nasdaq")
                            } label: {
                                ZStack {
                                    VStack {
                                        Image("nasdaq_logo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 170, height: 180)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Text("Nasdaq")
                                                .font(.title.bold())
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                }
                            }
                            
                            NavigationLink {
                                MarketDetail(type: "market", name: "nyse")
                            } label: {
                                ZStack {
                                    VStack {
                                        Image("nyse_logo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 170, height: 180)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Text("NYSE")
                                                .font(.title.bold())
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                }
                            }
      
                        }
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Sector")
                                .font(.largeTitle.bold())
                            
                            Spacer()
                        }
                        VStack(spacing: 20) {
                            HStack {
                                if isEnglish {
                                    SectorNavigator(type: "sector", name: "Technology", imagename: "Technology", textname: "Technology")
                                    
                                    SectorNavigator(type: "sector", name: "Communication Services", imagename: "CommunicationServices", textname: "Communication Services")
                                } else {
                                    SectorNavigator(type: "sector", name: "Technology", imagename: "Technology", textname: "기술주")
                                    
                                    SectorNavigator(type: "sector", name: "Communication Services", imagename: "CommunicationServices", textname: "커뮤니케이션 서비스주")
                                }
                                
                               
                            }
                            
                            HStack {
                                if isEnglish {
                                    SectorNavigator(type: "sector", name: "Consumer Cyclical", imagename: "ConsumerCyclical", textname: "Consumer Cyclical")
                                    
                                    SectorNavigator(type: "sector", name: "Consumer Defensive", imagename: "ConsumerDefensive", textname: "Consumer Defensive")
                                } else {
                                    SectorNavigator(type: "sector", name: "Consumer Cyclical", imagename: "ConsumerCyclical", textname: "경기순환주")
                                    
                                    SectorNavigator(type: "sector", name: "Consumer Defensive", imagename: "ConsumerDefensive", textname: "경기방어주")
                                }
                                
                            }
                            
                            HStack {
                                if isEnglish {
                                    SectorNavigator(type: "sector", name: "Financial Services", imagename: "Financials", textname: "Financials")
                                    
                                    SectorNavigator(type: "sector", name: "Healthcare", imagename: "Healthcare", textname: "Healthcare")
                                } else {
                                    SectorNavigator(type: "sector", name: "Financial Services", imagename: "Financials", textname: "금융주")
                                    
                                    SectorNavigator(type: "sector", name: "Healthcare", imagename: "Healthcare", textname: "헬스케어주")
                                }
                                
                            }
                            
                            HStack {
                                if isEnglish {
                                    SectorNavigator(type: "sector", name: "Industrials", imagename: "Industrials", textname: "Industrials")
                                    
                                    SectorNavigator(type: "sector", name: "Real Estate", imagename: "RealEstate", textname: "Real Estate")
                                } else {
                                    SectorNavigator(type: "sector", name: "Industrials", imagename: "Industrials", textname: "산업주")
                                    
                                    SectorNavigator(type: "sector", name: "Real Estate", imagename: "RealEstate", textname: "부동산주")
                                }
                            }
                            
                            HStack {
                                if isEnglish {
                                    SectorNavigator(type: "sector", name: "Utilities", imagename: "Utilities", textname: "Utilities")
                                    
                                    SectorNavigator(type: "sector", name: "Energy", imagename: "Energy", textname: "Energy")
                                } else {
                                    SectorNavigator(type: "sector", name: "Utilities", imagename: "Utilities", textname: "유틸리티주")
                                    
                                    SectorNavigator(type: "sector", name: "Energy", imagename: "Energy", textname: "에너지주")
                                }
                                
                            }
                            
                            HStack {
                                if isEnglish {
                                    SectorNavigator(type: "sector", name: "Basic Materials", imagename: "BasicMaterials", textname: "Basic Materials")
                                    
                                    Spacer()
                                } else {
                                    SectorNavigator(type: "sector", name: "Basic Materials", imagename: "BasicMaterials", textname: "원자재주")
                                    
                                    Spacer()
                                }
                                
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    // MARK: KRX
                    VStack(spacing: 5) {
                        HStack {
                            if isEnglish {
                                Text("Korean Market")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                            } else {
                                Text("한국 주식 시장")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }

                        NavigationLink {
                            KRXView()
                        } label: {
                            Image("krx")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350, height: 220)
                        }
                        

                    }
                    .padding(.top, 10)
                }
                .padding(.top, 10)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func SectorNavigator(type: String, name: String, imagename: String, textname: String) -> some View {
        NavigationLink {
            SectorDetail(type: type, name: name)
        } label: {
            ZStack {
                VStack {
                    Image(imagename)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 170, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                VStack(alignment: .trailing) {
                    Spacer()
                    Text(textname)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 100)
                }
                .padding()
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

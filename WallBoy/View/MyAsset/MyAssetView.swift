//
//  MyAssetView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI

struct MyAssetView: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject var ownStockVM = OwnStockViewModel()
    @StateObject var stockInfoVM = StockInfoViewModel()
    @AppStorage("userID") var userID = ""
    
    @AppStorage("isEnglish") private var isEnglish = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10){
                    ForEach(ownStockVM.ownStock, id: \.self){ stock in
                        NavigationLink {
                            MyStockView(stock: stock)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: getImageURL(symbol: stock.symbol))) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .shadow(radius: 7)
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(.trailing, 10)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    if isEnglish {
                                        Text(getCompanyName(symbol: stock.symbol))
                                            .foregroundColor(.primary)
                                    } else {
                                        Text(getCompanyNameKR(symbol: stock.symbol))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text(stock.symbol)
                                        .foregroundColor(.primary)
                                }
                                .font(.callout.bold())
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 10) {
                                    Text(stock.price)
                                        .foregroundColor(.primary)
                                    Text(stock.quantity)
                                        .foregroundColor(Color.gray)
                                }
                                .font(.callout.bold())
                            }
                            .padding(.vertical)
                        }
                        Divider()
                    }
                }
                .padding()
                .onAppear {
                    ownStockVM.fetchLoad(userId: userID)
                }
            }
            .navigationTitle("보유종목")
        }
    }
    
    func getImageURL(symbol: String) -> String {
        var url = ""
        var filteredStocks: [StockInformation] {
            modelData.stockInfo.filter { stock in
                stock.symbol.contains(symbol)
            }
        }
        for i in filteredStocks {
            if i.symbol == symbol {
                url = i.logoURL
            }
        }
        return url
    }
    
    func getCompanyName(symbol: String) -> String {
        var name = ""
        
        var filteredStocks: [StockInformation] {
            modelData.stockInfo.filter { stock in
                stock.symbol.contains(symbol)
            }
        }
        
        for i in filteredStocks {
            if i.symbol == symbol {
                name = i.name
            }
        }
        
        return name
    }
    
    func getCompanyNameKR(symbol: String) -> String {
        var nameKR = ""
        
        var filteredStocks: [StockInformation] {
            modelData.stockInfo.filter { stock in
                stock.symbol.contains(symbol)
            }
        }
        
        for i in filteredStocks {
            if i.symbol == symbol {
                nameKR = i.nameKR
            }
        }
        
        return nameKR
    }
    
    func twoDecimalConverter(value: String) -> String {
        let doubledNumber = Double(value)!
        let convertedNumber = String(format: "%.02f", doubledNumber)
        return convertedNumber
    }
}

struct MyAssetView_Previews: PreviewProvider {
    static var previews: some View {
        MyAssetView()
    }
}

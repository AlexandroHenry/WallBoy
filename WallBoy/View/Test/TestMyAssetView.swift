//
//  TestMyAssetView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/04.
//

import SwiftUI

struct TestMyAssetView: View {
    @AppStorage("userID") var userID = ""
    @StateObject var ownStockVM = OwnStockViewModel()
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationView {
            VStack{
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
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .shadow(radius: 7)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text(stock.symbol)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(stock.price)
                                    .foregroundColor(.primary)
                                Text(stock.quantity)
                                    .foregroundColor(Color.gray)
                            }
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .onAppear {
                ownStockVM.fetchLoad(userId: "CZ9dGfwIryPEGtDGZ93JMELmKGk2")
            }
        }
    }
    
    func getImageURL(symbol: String) -> String {
        var filteredStocks: [StockInformation] {
            modelData.stockInfo.filter { stock in
                stock.symbol.contains(symbol)
            }
        }
        
        return filteredStocks[0].logoURL
    }
    
    func twoDecimalConverter(value: String) -> String {
        let doubledNumber = Double(value)!
        let convertedNumber = String(format: "%.02f", doubledNumber)
        return convertedNumber
    }
}

struct TestMyAssetView_Previews: PreviewProvider {
    static var previews: some View {
        TestMyAssetView()
    }
}

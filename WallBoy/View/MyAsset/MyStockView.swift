//
//  MyStockView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import SwiftUI

struct MyStockView: View {
    @EnvironmentObject var modelData: ModelData
    @AppStorage("isEnglish") private var isEnglish = true
    
    @State private var showModal = false
    @State var stock: OwnStock
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: getImageURL(symbol: stock.symbol))) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
//                    .clipShape(Circle())
//                    .overlay {
//                        Circle().stroke(.white, lineWidth: 4)
//                    }
                    .shadow(radius: 7)
            } placeholder: {
                ProgressView()
            }
            
            HStack {
                Spacer()
                
                NavigationLink {
                    StockBuyView(symbol: stock.symbol)
                } label: {
                    Text("Buy")
                }
                .frame(width: 180, height: 80)
                .background(.green)
                
                Spacer()
                
                NavigationLink {
                    StockSellView(stock: stock)
                } label: {
                    Text("Sell")
                }
                .frame(width: 180, height: 80)
                .background(.red)
                
                
                Spacer()
            }
            .font(.title.bold())
            .foregroundColor(.white)
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
}

struct MyStockView_Previews: PreviewProvider {
    static var previews: some View {
        MyStockView(stock: OwnStock(owner: "testUser", symbol: "AAPL", price: "100", quantity: "100"))
    }
}


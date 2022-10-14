//
//  StockTransactionCalendarView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/30.
//

import SwiftUI

struct StockTransactionCalendarView: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject var stockHistoryVM = StockHistoryViewModel()
    @AppStorage("userID") var userID = ""
    @AppStorage("isEnglish") private var isEnglish = true
    
    var body: some View {
       
        VStack {
            HStack{
                if isEnglish {
                    Text("Transaction")
                        .font(.largeTitle.bold())
                } else {
                    Text("거래 내역")
                        .font(.largeTitle.bold())
                }
                
                Spacer()
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(stockHistoryVM.stockHistory) { item in
                        VStack(spacing: 10) {
                            HStack {
                                AsyncImage(url: URL(string: getData(symbol: item.symbol).logoURL)) { image in
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
                                
                                if isEnglish {
                                    Text("\(getData(symbol: item.symbol).name)(\(item.symbol))")
                                        .font(.callout.bold())
                                    Spacer()
                                    Text(item.action)
                                } else {
                                    Text("\(getData(symbol: item.symbol).nameKR)(\(item.symbol))")
                                        .font(.callout.bold())
                                    Spacer()
                                    if item.action == "sell" {
                                        Text("매도")
                                    } else {
                                        Text("매수")
                                    }
                                }
                            }
                            .font(.title3.bold())
                            
                            if isEnglish {
                                Text("Avg.price: \(item.price)")
                                Text("Quantity: \(item.quantity)")
                            } else {
                                Text("평균가격: \(item.price)")
                                Text("수량: \(item.quantity)")
                            }
                            Text((item.date).substring(from: 0, to: 15))
                            
                        }
                        .frame(width: 300, height: 150)
                        .padding()
                        .background(item.action == "buy" ? .green : .orange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .padding()
        .onAppear{
            stockHistoryVM.fetchHistoryLoading(owner: userID)
        }
    }

    
    func avgPrice(price: String, quantity: String) -> String {
        
        let numPrice = Double(price)!
        let numQuantity = Double(quantity)!
        
        let avgPrice = (numPrice / numQuantity)
        let convertedAvgPrice = String(format: "%.2f", avgPrice)
        
        return convertedAvgPrice
    }
    
    func getData(symbol: String) -> StockInformation {
        var filteredStocks: [StockInformation] {
            modelData.stockInfo.filter { stock in
                stock.symbol.contains(symbol)
            }
        } 
        return filteredStocks[0]
    }
}

struct StockTransactionCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        StockTransactionCalendarView()
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}

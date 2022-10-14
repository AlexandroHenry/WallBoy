//
//  StockPurchaseView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import SwiftUI

struct StockBuyView: View {
    
//    @State var stock: StockDetail
    
    @State var symbol: String
    
    @StateObject var stockInfoVM = StockInfoViewModel()
    @StateObject var stockHistoryVM = StockHistoryViewModel()
    @StateObject var ownStockVM = OwnStockViewModel()
    
    @State var bidAmount: String = ""
    @State private var showModal = false
    
    @AppStorage("userID") var userID = ""
    @AppStorage("isEnglish") private var isEnglish = true
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text(self.symbol)
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding()
            
            HStack {
                Text("$")
                
                if bidAmount == "" || bidAmount == "0." {
                    Text("0")
                        .font(.system(size: 50))
                } else {
                    Text(bidAmount)
                        .font(.system(size: 50))
                }
                
            }
            
            if bidAmount != "" && stockInfoVM.stockInfo.financialData.currentPrice != nil {
                if isEnglish {
                    Text("\(stockQuantity()) 주")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                } else {
                    Text("Quantity: \(stockQuantity())")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                }
            } else if bidAmount == "" || bidAmount == "0." {
                if isEnglish {
                    Text("Quantity: 0")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                } else {
                    Text("0 주")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                }
            }
            
            Group {
                HStack {
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("1")
                            .onTapGesture {
                                bidAmount += "1"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("2")
                            .onTapGesture {
                                bidAmount += "2"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("3")
                            .onTapGesture {
                                bidAmount += "3"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("4")
                            .onTapGesture {
                                bidAmount += "4"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("5")
                            .onTapGesture {
                                bidAmount += "5"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("6")
                            .onTapGesture {
                                bidAmount += "6"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("7")
                            .onTapGesture {
                                bidAmount += "7"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("8")
                            .onTapGesture {
                                bidAmount += "8"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("9")
                            .onTapGesture {
                                bidAmount += "9"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text(".")
                            .onTapGesture {
                                let dotCount = bidAmount.filter{$0 == "."}.count
                                
                                if dotCount < 1 {
                                    if bidAmount == "" {
                                        bidAmount += "0."
                                    } else {
                                        bidAmount += "."
                                    }
                                }
                                
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("0")
                            .onTapGesture {
                                bidAmount += "0"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("⌫")
                            .onTapGesture {
                                if bidAmount != "" {
                                    bidAmount.removeLast()
                                }
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                }
            }
            .padding(.bottom, 10)
            
            Button {
                
                stockHistoryVM.fetchHistory(userId: userID, action: "buy", symbol: self.symbol, price: priceConverter(), quantity: stockQuantity())
                
                ownStockVM.fetchBuy(userId: userID, symbol: self.symbol, price: priceConverter(), quantity: stockQuantity())
                
                if Double(bidAmount)! > 0 {
                    self.showModal = true
                }

            } label : {
                if isEnglish {
                    Text("Purchase")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                } else {
                    Text("결제하기")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
            }
            // 구매후 모달
            .sheet(isPresented: self.$showModal) {
                
                if bidAmount != "" || bidAmount != "0" || bidAmount != "0." {
                    BuyModalView(symbol: self.symbol, bidAmount: bidAmount, stockAmount: stockQuantity(), showModal: $showModal)
                }
                
            }
            .frame(width: UIScreen.screenWidth * 0.6, height: 50)
            .background(.green)
            .clipShape(Capsule())
            
        }
        .font(.largeTitle.bold())
        .foregroundColor(.green.opacity(0.8))
        .onAppear {
            stockInfoVM.fetch(symbol: self.symbol)
        }
        .offset(y: -50)
        
    }
    
    func stockQuantity() -> String {
        let currentPrice = stockInfoVM.stockInfo.financialData.currentPrice
        
        let bidAmount = Double(self.bidAmount)!
        
        let quantity =  bidAmount / currentPrice
        
        let convertedQuantityString = String(format: "%.02f", quantity)
        
        return convertedQuantityString
    }
    
    func priceConverter() -> String {
        let convertedNumber = String(format: "%.02f", stockInfoVM.stockInfo.financialData.currentPrice)
        return convertedNumber
    }
}

struct StockBuyView_Previews: PreviewProvider {
    static var stocks = ModelData().stockInfo
    
    static var previews: some View {
        StockBuyView(symbol: "AAPL")
    }
}

struct BuyModalView: View {
    
    @State var symbol: String
    @State var bidAmount: String
    @State var stockAmount: String
    @State private var timeRemaining = 10
    
    @Binding var showModal: Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack (spacing: 30){
                
                Text("축하합니다!")
                    .font(.largeTitle.bold())
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 150))
                
//                Text("\(stock.namekr) (\(stock.symbol))")
                Text("\(self.symbol)")
                HStack {
                    Text("결제금액: $")
                    Text("\(bidAmount)")
                }
                
                HStack {
                    Text("구매수량: ")
                    Text("\(stockAmount) 주")
                }
                
                Button {
                    self.showModal.toggle()
                    
                    // 여기다가 view 옮겨주는 function 필요
                } label: {
                    Text("닫기")
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.screenWidth * 0.6, height: 50)
                .background(.green)
                .clipShape(Capsule())
                
                Text("\(timeRemaining) 초 후에 자동으로 창이 사라집니다.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                
            }
            .padding(50)
            .offset(y: -10)
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer.upstream.connect().cancel()
                    
                }
            }
            .font(.title2.bold())

        }
    }
}

//
//  MyStockPurchaseView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/21.
//

import SwiftUI

struct StockSellView: View {
    
    @State var stock: OwnStock
    @State var quantity: String = ""
    @State private var showModal = false
    
    @StateObject var stockInfoVM = StockInfoViewModel()
    @StateObject var stockHistoryVM = StockHistoryViewModel()
    @StateObject var ownStockVM = OwnStockViewModel()
    
    @AppStorage("userID") var userID = ""
    
    var body: some View {
        VStack(spacing: 10) {
            
            if quantity == "0" || quantity == "" {
                Text(stock.symbol)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                Text("0 주")
                
                Text("$ 0")
                
                Text("보유량: \(stock.quantity) 주")
                    .font(.title3.bold())
            } else {
                Text(stock.symbol)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                
                Text("\(quantity) 주")

                Text("$ \(totalPrice())")
                
                Text("보유량: \(stock.quantity) 주")
                    .font(.title3.bold())
            }
            
            Group {
                HStack {
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("1")
                            .onTapGesture {
                                quantity += "1"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("2")
                            .onTapGesture {
                                quantity += "2"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("3")
                            .onTapGesture {
                                quantity += "3"
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
                                quantity += "4"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("5")
                            .onTapGesture {
                                quantity += "5"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("6")
                            .onTapGesture {
                                quantity += "6"
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
                                quantity += "7"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("8")
                            .onTapGesture {
                                quantity += "8"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("9")
                            .onTapGesture {
                                quantity += "9"
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
                                let dotCount = quantity.filter{$0 == "."}.count
                                
                                if dotCount < 1 {
                                    if quantity == "" {
                                        quantity += "0."
                                    } else {
                                        quantity += "."
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
                                quantity += "0"
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                    
                    ZStack{
                        Circle()
                            .stroke(.primary.opacity(0))
                        
                        Text("⌫")
                            .onTapGesture {
                                if quantity != "" {
                                    quantity.removeLast()
                                }
                            }
                    }
                    .frame(width: 80, height: 80)
                    
                    Spacer()
                }
            }
            
            Button {
                
                if Double(stock.quantity)! >= Double(quantity)! {
                    stockHistoryVM.fetchHistory(userId: userID, action: "sell", symbol: stock.symbol, price: totalPrice(), quantity: self.quantity)
                    
                    ownStockVM.fetchSell(userId: userID, symbol: stock.symbol, price: totalPrice(), quantity: self.quantity)
                    
                    self.showModal = true
                }

            } label : {
                Text("결제하기")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            // 판매후 모달
            .sheet(isPresented: self.$showModal) {
                
                if quantity != "" || quantity != "0" || quantity != "0." {
                    if Double(stock.quantity)! >= Double(quantity)! {
                        SellModalView(symbol: stock.symbol, quantity: self.quantity, priceAmount: totalPrice(), showModal: $showModal)
                    }
                }
                
            }
            .frame(width: UIScreen.screenWidth * 0.6, height: 50)
            .background(.orange)
            .clipShape(Capsule())
            
        }
        .font(.largeTitle.bold())
        .foregroundColor(.orange.opacity(0.8))
        .onAppear {
            stockInfoVM.fetch(symbol: stock.symbol)
        }
        .offset(y: -50)
    }
    
    func totalPrice() -> String{
        
        let currentPrice = Double(stockInfoVM.stockInfo.financialData.currentPrice)
        let quantity = Double(self.quantity)!
        let total = currentPrice * quantity
        
        let price = String(format: "%.02f", total)
        
        return price
    }
    
}

struct StockSellView_Previews: PreviewProvider {
    static var previews: some View {
        StockSellView(stock: OwnStock(owner: "Tester", symbol: "AAPL", price: "123", quantity: "2000"))
    }
}

struct SellModalView: View {
    
    @State var symbol: String
    @State var quantity: String
    
    @State var priceAmount: String
    @State private var timeRemaining = 10
    
    @Binding var showModal: Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack (spacing: 30){
            
            Text("축하합니다!")
                .font(.largeTitle.bold())
            
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 150))
            
            Text("\(self.symbol)")
            HStack {
                Text("결제금액: $")
                Text("\(priceAmount)")
            }
            
            HStack {
                Text("판매수량: ")
                Text("\(quantity) 주")
            }
            
            NavigationLink {
                MyAssetView()
            } label: {
                Text("닫기")
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.screenWidth * 0.6, height: 50)
            .background(.orange)
            .clipShape(Capsule())
            .onTapGesture {
                self.showModal.toggle()
            }
            
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

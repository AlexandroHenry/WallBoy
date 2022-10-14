//
//  MyInfoView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/19.
//

import SwiftUI

struct MyInfoView: View {
    
    @StateObject var myInfoVM = MyInfoViewModel()
    @AppStorage("userID") var userID = ""
    @AppStorage("isEnglish") private var isEnglish = true
    @StateObject var mystockcurrentpriceVM = MyStockCurrentPriceViewModel()
    @StateObject var ownStockVM = OwnStockViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                
                Text("\(myInfoVM.userInfo.result.nickname)님의 계좌 현황")
                    .font(.largeTitle.bold())
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                if totalStockValue() != 0.000000 {
                    
                    if isEnglish {
                        PieChartView(values: [toDouble(stringNum: myInfoVM.userInfo.result.cash), totalStockValue()], names: ["Cash", "Stock"], formatter: {value in String(format: "$%.2f", value)})
                    } else {
                        PieChartView(values: [toDouble(stringNum: myInfoVM.userInfo.result.cash), totalStockValue()], names: ["현금", "주식"], formatter: {value in String(format: "$%.2f", value)})
                    }
                    
                } else {
                    ProgressView(value: totalStockValue())
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .padding()
                }

            }
            .padding()
            .font(.title3.bold())
            .onAppear {
                myInfoVM.fetchUserInfo(userId: userID)
                mystockcurrentpriceVM.fetchUserStocks(userId: userID)
                ownStockVM.fetchLoad(userId: userID)
            }
        }
    }
    
    func toDouble(stringNum: String) -> Double {
        let value = Double(stringNum)
        return value ?? 0
    }
    
    func totalStockValue() -> Double {
        
        var sum: Double = 0
        
        for i in mystockcurrentpriceVM.mystockcurrentprice {
            for j in ownStockVM.ownStock {
                if i.symbol == j.symbol {
                    sum += (i.adjclose * Double(j.quantity)!)
                }
            }
        }
        
        return sum
    }
    
}

struct MyInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MyInfoView()
    }
}



//
//  SP500View.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/28.
//

import SwiftUI

struct SP500View: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("S&P500")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                Spacer()
            }
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(splitArray(input: modelData.sp500list), id: \.self) { stock in
                        HStack {
                            ForEach(stock, id: \.self) { item in
                                VStack {
                                    Text(item.name)
                                    Text("(\(item.symbol))")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func filteredStock(symbol: String) -> [StockInformation] {
        var filteredStocks: [StockInformation] {
            modelData.stockInfo.filter { stock in
                stock.symbol.contains(symbol)
            }
        }
        return filteredStocks
    }
    
    
    func splitArray(input: [SP500List]) -> [[SP500List]] {
        
        var splitedArray: [SP500List] = []
        var output: [[SP500List]] = []

        let count = input.count
        var spliter = 0
        
        for item in input {
            splitedArray.append(item)
            spliter += 1
            
            if spliter == 3 {
                output.append(splitedArray)
                spliter = 0
                splitedArray = []
            }
        }

        return output
    }
}

struct SP500View_Previews: PreviewProvider {
    static var previews: some View {
        SP500View()
    }
}

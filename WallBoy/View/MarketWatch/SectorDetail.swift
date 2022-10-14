//
//  SectorDetail.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/27.
//

import SwiftUI

struct SectorDetail: View {
    @EnvironmentObject var modelData: ModelData
    
    @State var type: String
    @State var name: String
    
    var filteredStocks: [StockInformation] {
        modelData.stockInfo.filter { stock in
            stock.sector.contains(name)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(name.uppercased())
                    .font(.title.bold())
                    .foregroundColor(.primary)
                Spacer()
            }
            
            ScrollView {
                LazyVStack(spacing: 30) {
                    ForEach(splitArray(input: filteredStocks), id: \.self) { stock in
                        HStack {
                            ForEach(stock, id: \.self) { item in
                                StockInfoNavigation(stock: item)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    func splitArray(input: [StockInformation]) -> [[StockInformation]] {
        
        var splitedArray: [StockInformation] = []
        var output: [[StockInformation]] = []

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

struct SectorDetail_Previews: PreviewProvider {
    static var previews: some View {
        SectorDetail(type: "sector", name: "Consumer Cyclical")
    }
}

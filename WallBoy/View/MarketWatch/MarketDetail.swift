//
//  MarketDetail.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/26.
//

import SwiftUI

struct MarketDetail: View {
    @EnvironmentObject var modelData: ModelData
    
    @State var type: String
    @State var name: String
    
    
    var filteredStocks: [StockInformation] {
        modelData.stockInfo.filter { stock in
            stock.market.contains(name)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(name.uppercased())
                    .font(.largeTitle.bold())
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
    
    
    // 기존의 Array의 아이템을 3개씩 나눠서 새로운 Array에 담고 또 그걸 하나의 Array에 append 후
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

struct MarketDetail_Previews: PreviewProvider {
    static var previews: some View {
        MarketDetail(type: "market", name: "nasdaq")
            .environmentObject(ModelData())
    }
}

struct StockInfoView: View {
    @State var stock: StockInformation
    @AppStorage("isEnglish") private var isEnglish = true
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: stock.logoURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: 4)
                    }
                    .shadow(radius: 7)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                
                if isEnglish {
                    Text(stock.name)
                        .font(.title.bold())
                    
                    HStack {
                        Text(stock.name)
                        Spacer()
                        Text(stock.market.uppercased())
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("About \(stock.name)")
                        .font(.title3.bold())
                    
                    ScrollView {
                        Text(stock.descriptionEng)
                    }
                } else {
                    Text(stock.nameKR)
                        .font(.title.bold())
                    
                    HStack {
                        Text(stock.name)
                        Spacer()
                        Text(stock.market.uppercased())
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("About \(stock.name)")
                        .font(.title3.bold())
                    
                    ScrollView {
                        Text(stock.descriptionKR)
                    }
                }
                
            }

            Spacer()
            
        }
        .padding()
    }
}

struct StockInfoNavigation: View {
    @State var stock: StockInformation
    @AppStorage("isEnglish") private var isEnglish = true
    
    var body: some View {
        NavigationLink {
            StockInfoView(stock: stock)
        } label: {
            VStack {
                AsyncImage(url: URL(string: stock.logoURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                } placeholder: {
                    ProgressView()
                }
                
                if isEnglish {
                    Text(stock.name)
                    Text("(\(stock.symbol))")
                } else {
                    Text(stock.nameKR)
                    Text("(\(stock.symbol))")
                }
                
            }
            .font(.caption.bold())
            .frame(width: 120, height: 120)
            .foregroundColor(.primary)
        }
        .shadow(radius: 5)

    }
}


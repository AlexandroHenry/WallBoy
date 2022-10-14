//
//  KRXView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/29.
//

import SwiftUI

struct KRXView: View {
    @EnvironmentObject var modelData: ModelData
    
    var sortedModels: [StockKRDetail] {
        get {
            modelData.krxlist.sorted(by: { $0.marketCap > $1.marketCap })
        }
        set {
            modelData.krxlist = newValue
        }
    }
    
    var body: some View {
        List {
            ForEach(sortedModels, id: \.self) { item in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("\(item.name)(\(item.symbol))")
                        Spacer()
                        Text(item.market)
                    }
                    .font(.title2.bold())
                    
                    Text("섹터: \(item.sector)")
                    Text("산업군: \(item.industry)")
                    Text("웹페이지: \(item.webpage)")
                    Text("시가총액: \(item.marketCap)원")
                    Text("상장 주식수: \(item.volume)")
                }
            }
        }
    }
}

struct KRXView_Previews: PreviewProvider {
    static var previews: some View {
        KRXView()
    }
}

//
//  Indices.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/05.
//

import SwiftUI

struct IndicesView: View {
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    Text("US Market")
                    Spacer()
                }
                .font(.largeTitle.bold())
                
                HStack {
                    Spacer()
                    MediumFuturesButtonView(symbol: "^DJI")
                    Spacer()
                    MediumFuturesButtonView(symbol: "^IXIC")
                    Spacer()
                }
                
                LargeFuturesButtonView(symbol: "^GSPC")
                
                HStack {
                    Spacer()
                    MediumFuturesButtonView(symbol: "^VIX")
                    Spacer()
                    MediumFuturesButtonView(symbol: "^RUT")
                    Spacer()
                }
                
                HStack {
                    Text("Korea Market")
                    Spacer()
                }
                .padding(.top, 10)
                .font(.largeTitle.bold())
                
                HStack {
                    Spacer()
                    MediumFuturesButtonView(symbol: "^KS11")
                    Spacer()
                    MediumFuturesButtonView(symbol: "^KQ11")
                    Spacer()
                }
                
                HStack {
                    Text("Asian Market")
                    Spacer()
                }
                .padding(.top, 10)
                .font(.largeTitle.bold())
                
                SmallFuturesButtonView(symbol: "^N225")
                SmallFuturesButtonView(symbol: "^HSI")
                SmallFuturesButtonView(symbol: "000300.SS")
            }
            .padding()
        }
    }
}

struct IndicesView_Previews: PreviewProvider {
    static var previews: some View {
        IndicesView()
    }
}

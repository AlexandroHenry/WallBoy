//
//  LargeIndexButtonView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/06.
//

import SwiftUI
import Charts

struct LargeFuturesButtonView: View {
    var symbol: String
    
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var futuresVM = FuturesViewModel()
    @StateObject var futuresHistoryVM = FuturesHistoryViewModel()
    
    var body: some View {
        NavigationLink {
            FuturesDetailView(symbol: symbol)
        } label: {
            VStack(alignment: .leading) {
                ForEach(futuresVM.futures, id: \.self) { item in
                    
                    HStack {
                        if isEnglish {
                            Text("\(item.name)  (\(item.symbol))")
                        } else {
                            Text("\(item.nameKR)  (\(item.symbol))")
                        }
                        
                        Spacer()
                        Text("\(String(format: "%.02f", item.regularMarketPrice))")
                    }
                    .font(.title3.bold())
                    .frame(width: UIScreen.screenWidth * 0.8)
                    .padding(.top, 20)
                    
                    timeseriesLineChart()
                   
                }
            }
            .font(.system(size: 14).bold())
            .foregroundColor(isDarkMode ? .black.opacity(0.8) : .white)
            .padding()
            .frame(width: UIScreen.screenWidth * 0.93, height: UIScreen.screenHeight * 0.2)
            .background(isDarkMode ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onAppear {
                futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "3mo")
                futuresVM.fetchFutures(symbol: symbol)
            }
        }
    }
    
    @ViewBuilder
    func timeseriesLineChart() -> some View {
        let max = futuresHistoryVM.futuresHistory.max { item1, item2 in
            return item2.adjClose > item1.adjClose
        }?.adjClose ?? 0
        
        let min = futuresHistoryVM.futuresHistory.min { item1, item2 in
            return item2.adjClose > item1.adjClose
        }?.adjClose ?? 0
        
        Chart {
            ForEach(futuresHistoryVM.futuresHistory, id: \.self) { item in
                LineMark(
                    x: .value("Day", item.date),
                    y: .value("Close", item.adjClose)
                )
                .foregroundStyle(.green.gradient)
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartOverlay(content: { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
            }
        })
        .chartYScale(domain: (min-(min*0.1))...(max+(max*0.1)))
        .contentShape(RoundedRectangle(cornerRadius: 15))
        .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.14)
        .padding(.horizontal, 5)
    }
}

struct LargeFuturesButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LargeFuturesButtonView(symbol: "HO=F")
    }
}

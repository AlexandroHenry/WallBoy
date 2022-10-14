//
//  FutureIndexButtonView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/06.
//

import SwiftUI
import Charts

struct MediumFuturesButtonView: View {
    var symbol: String
    
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("isDarkMode") private var isDarkMode = true
    @StateObject var futuresVM = FuturesViewModel()
    @StateObject var futuresHistoryVM = FuturesHistoryViewModel()
    
    var body: some View {
        NavigationLink {
            FuturesDetailView(symbol: symbol)
        } label : {
            VStack {
                ForEach(futuresVM.futures, id: \.self) { item in
                    if isEnglish {
                        Text(item.name)
                        Spacer()
                        timeseriesLineChart()
                        Spacer()
                        Text("\(String(format: "%.02f", item.regularMarketPrice))")
                    } else {
                        Text(item.nameKR)
                        Spacer()
                        timeseriesLineChart()
                        Spacer()
                        Text("\(String(format: "%.02f", item.regularMarketPrice))")
                    }
                   
                }
            }
            .font(.system(size: 18).bold())
            .foregroundColor(isDarkMode ? .black.opacity(0.9) : .white)
            .padding()
            .frame(width: UIScreen.screenWidth * 0.45, height: UIScreen.screenHeight * 0.22)
            .background(isDarkMode ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onAppear {
                futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "1mo")
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
        .frame(width: UIScreen.screenWidth * 0.3, height: UIScreen.screenHeight * 0.1)
        .padding(.horizontal, 5)
    }
}

struct MediumFuturesButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MediumFuturesButtonView(symbol: "^KS11")
    }
}

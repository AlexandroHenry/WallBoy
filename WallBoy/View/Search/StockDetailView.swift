//
//  StockDetailView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    @State var stock: StockInformation
    @StateObject var stockInfoVM = StockInfoViewModel()
    @StateObject var timeseriesVM = TimeSeriesViewModel()
    @StateObject var dailyStockVM = DailyStockViewModel()
    
    @State var currentTab: String = "3mo"
    
    // MARK: Gesture Properties
    @State var currentActiveItem: TimeSeries?
    @State var currentDailyActiveItem: DailyStock?
    @State var plotWidth: CGFloat = 0
    
    @AppStorage("isEnglish") private var isEnglish = true
    
    var body: some View {

        VStack {
            HStack(spacing: 20) {
                
                AsyncImage(url: URL(string: stock.logoURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .shadow(radius: 7)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading) {
                    if isEnglish {
                        Text(stock.name)
                            .font(.title.bold())

                    } else {
                        Text(stock.nameKR)
                            .font(.title.bold())
                        
                        Text(stock.name)
                            .font(.footnote.bold())
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(closePrice())
                        .font(.title.bold())
                    
                    Text("\( priceChange() ) (\( percentageChange() )%)")
                        .font(.footnote.bold())
                }
                .foregroundColor(stockInfoVM.stockInfo.financialData.currentPrice - stockInfoVM.stockInfo.summaryDetail.previousClose > 0 ? .green : .red)
            }
            
            if currentTab == "1w" || currentTab == "1mo" || currentTab == "3mo" || currentTab == "1y" || currentTab == "max" {
                timeseriesLineChart()
                    .offset(y: -10)
            } else if currentTab == "1d" {
                dailyLineChart()
                    .offset(y: -10)
            }
            
            HStack(spacing: 30) {
                Spacer()
                Text("1D")
                    .onTapGesture {
                        currentTab = "1d"
                        dailyStockVM.fetch(symbol: stock.symbol)
                    }
                
                Text("1W")
                    .onTapGesture {
                        currentTab = "1w"
                        timeseriesVM.fetch(symbol: stock.symbol, period: "5d", interval: "1d")
                    }
                
                Text("1M")
                    .onTapGesture {
                        currentTab = "1mo"
                        timeseriesVM.fetch(symbol: stock.symbol, period: "1mo", interval: "1d")
                    }
                
                Text("3M")
                    .onTapGesture {
                        currentTab = "3mo"
                        timeseriesVM.fetch(symbol: stock.symbol, period: "3mo", interval: "1d")
                    }
                
                Text("1Y")
                    .onTapGesture {
                        currentTab = "1y"
                        timeseriesVM.fetch(symbol: stock.symbol, period: "1y", interval: "1d")
                    }
                
                Spacer()
            }
            .font(.callout)
            .foregroundColor(.green)
            .padding(.bottom, 10)
            
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        if isEnglish {
                            Text("Close")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        } else {
                            Text("종가")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("\(twoDecimalConverter(value: stockInfoVM.stockInfo.financialData.currentPrice))")
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        if isEnglish {
                            Text("Open")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        } else {
                            Text("시가")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
 
                        Text("\(twoDecimalConverter(value: stockInfoVM.stockInfo.summaryDetail.previousClose))")
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        if isEnglish {
                            Text("High")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        } else {
                            Text("고가")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }

                        Text("\(twoDecimalConverter(value: stockInfoVM.stockInfo.summaryDetail.regularMarketDayHigh))")
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        if isEnglish {
                            Text("low")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        } else {
                            Text("저가")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("\(twoDecimalConverter(value: stockInfoVM.stockInfo.summaryDetail.regularMarketDayLow))")
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                }
                
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        if isEnglish {
                            Text("Volume")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        } else {
                            Text("거래량")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }

                        Text("\(stockInfoVM.stockInfo.summaryDetail.regularMarketVolume)")
                            .font(.title3.bold())
                    }
                    
                    Spacer()
                }
                
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            NavigationLink {
                StockBuyView(symbol: stock.symbol)
            } label: {
                if isEnglish {
                    Text("Trade")
                        .foregroundColor(.white)
                        .font(.title3.bold())
                } else {
                    Text("구매")
                        .foregroundColor(.white)
                        .font(.title3.bold())
                }
                
            }
            .frame(width: UIScreen.screenWidth * 0.6, height: 50)
            .background(.green)
            .clipShape(Capsule())

        }
        .offset(y: -(UIScreen.screenHeight * 0.04))
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear{
            stockInfoVM.fetch(symbol: stock.symbol)
            timeseriesVM.fetch(symbol: stock.symbol, period: "3mo", interval: "1d")
        }
        .padding()

    }
    
    @ViewBuilder
    func timeseriesLineChart() -> some View {
        let max = timeseriesVM.currentStock.max { item1, item2 in
            return item2.high > item1.high
        }?.high ?? 0
        
        let min = timeseriesVM.currentStock.min { item1, item2 in
            return item2.low > item1.low
        }?.low ?? 0
        
        
        Chart {
            ForEach(timeseriesVM.currentStock) { item in
                LineMark(
                    x: .value("Day", item.convertedDate.onlyDate!, unit: .day),
                    y: .value("Close", item.close)
                )
                .foregroundStyle(.green.gradient)
                
                
                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("Day", currentActiveItem.convertedDate.onlyDate!))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .annotation(position: .topLeading) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Date:")
                                        .font(.caption)
                                    Text(dateformatConvertor(date: currentActiveItem.convertedDate))
                                }
                
                                HStack {
                                    Text("Close:")
                                        .font(.caption)
                                    
                                    Text(twoDecimalConverter(value: currentActiveItem.close))
                                        .font(.title3.bold())
                                }
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                            .offset(y: 50)
                        }
                }
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartOverlay(content: { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                // MARK: Getting Current Location
                                let location = value.location
                                
                                // Extracting Value From The Location
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    let day = calendar.dateComponents([.year, .month, .day], from: date.onlyDate!)
                                    
                                    if let currentItem = timeseriesVM.currentStock.first(where: {item in
                                        calendar.dateComponents([.year, .month, .day], from: item.convertedDate.onlyDate!) == day
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            }.onEnded{ value in
                                self.currentActiveItem = nil
                            }
                    )
            }
        })
        .chartYScale(domain: (min-(min*0.1))...(max+(max*0.1)))
        .contentShape(RoundedRectangle(cornerRadius: 15))
        .frame(height: UIScreen.screenHeight * 0.3)
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    func dailyLineChart() -> some View {
        let max = dailyStockVM.dailyStock.max { item1, item2 in
            return item2.high > item1.high
        }?.high ?? 0
        
        let min = dailyStockVM.dailyStock.min { item1, item2 in
            return item2.low > item1.low
        }?.low ?? 0
        
        Chart {
            ForEach(dailyStockVM.dailyStock) { item in
                LineMark(
                    x: .value("Day", item.convertedDate),
                    y: .value("Close", item.close)
                )
                .foregroundStyle(.green.gradient)
                
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartYScale(domain: (min-(min*0.01))...(max+(max*0.01)))
        .contentShape(RoundedRectangle(cornerRadius: 15))
        .frame(height: UIScreen.screenHeight * 0.3)
        .padding(.horizontal, 5)
    }
    
    // 종가 : previousClose
    // 현재가 : currentPrice
    
    func priceChange() -> String {
        let close = stockInfoVM.stockInfo.financialData.currentPrice
        let previousClose = stockInfoVM.stockInfo.summaryDetail.previousClose
        
        let change =  close - previousClose
        let convertedChange = String(format: "%.02f", change)
        
        return convertedChange
    }
    
    func percentageChange() -> String {
        let close = stockInfoVM.stockInfo.financialData.currentPrice
        let previousClose = stockInfoVM.stockInfo.summaryDetail.previousClose
        
        let changeInPercent = ((close - previousClose) / previousClose) * 100
        let convertedPercent = String(format: "%.02f", changeInPercent)
        return convertedPercent
    }
    
    func closePrice() -> String {
        let close = stockInfoVM.stockInfo.financialData.currentPrice
        let convertedClose = String(format: "%.02f", close)
        
        return convertedClose
    }
    
    func dateformatConvertor(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    func twoDecimalConverter(value: Double) -> String {
        let convertedNumber = String(format: "%.02f", value)
        return convertedNumber
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var stocks = ModelData().stockInfo
    
    static var previews: some View {
        StockDetailView(stock: stocks[0])
    }
}

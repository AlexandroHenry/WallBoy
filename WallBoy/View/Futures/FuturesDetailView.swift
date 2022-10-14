//
//  FuturesDetailView.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/06.
//

import SwiftUI
import Charts

struct FuturesDetailView: View {
    var symbol: String
    
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var futuresHistoryVM = FuturesHistoryViewModel()
    @StateObject var futuresVM = FuturesViewModel()
    @State var currentTab: String = "3mo"
    
    // MARK: Gesture Properties
    @State var currentActiveItem: IndicesFuturesHistory?
    @State var plotWidth: CGFloat = 0
    
    var body: some View {
        VStack {
            
            ForEach(futuresVM.futures, id: \.self) { item in
                HStack {
                    Text(item.name)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    Text(String(format: "%.2f", item.regularMarketPrice))
                }
                .font(.title.bold())
                
                timeseriesLineChart()
                
                HStack(spacing: 25) {
                    Spacer()
                    Text("1w")
                        .onTapGesture {
                            currentTab = "1w"
                            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "1w")
                        }
                    
                    Text("1mo")
                        .onTapGesture {
                            currentTab = "1mo"
                            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "1mo")
                        }
                    
                    Text("3mo")
                        .onTapGesture {
                            currentTab = "3mo"
                            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "3mo")
                        }
                    
                    Text("6mo")
                        .onTapGesture {
                            currentTab = "6mo"
                            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "6mo")
                        }
                    
                    Text("1y")
                        .onTapGesture {
                            currentTab = "1y"
                            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "1y")
                        }
                    
                    Text("5Y")
                        .onTapGesture {
                            currentTab = "5y"
                            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "5y")
                        }
                    
                    Text("All")
                        .onTapGesture {
                            currentTab = "all"
                            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: "all")
                        }
                    
                    Spacer()
                }
                .font(.footnote.bold())
                .foregroundColor(.green)
                .padding(.bottom, 10)
                
                HStack {
                    Text("News")
                        .font(.title2.bold())
                    Spacer()
                }
                .padding(.top, 5)
 
                if isEnglish {
                    NewsListView(searchterm: item.name)
                } else {
                    NewsListView(searchterm: item.nameKR)
                }
            }
        }
        .padding(.horizontal, 10)
        .onAppear {
            futuresHistoryVM.fetchFuturesPeriodHistory(symbol: symbol, period: currentTab)
            futuresVM.fetchFutures(symbol: symbol)
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
                    x: .value("Day", item.date.toDate()!, unit: .day),
                    y: .value("Close", item.adjClose)
                )
                .foregroundStyle(.green.gradient)
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartYScale(domain: (min-(min*0.1))...(max+(max*0.1)))
        .contentShape(RoundedRectangle(cornerRadius: 15))
        .frame(height: UIScreen.screenHeight * 0.3)
        .padding(.horizontal, 5)
    }
}

struct FuturesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FuturesDetailView(symbol: "^DJI")
    }
}

struct NewsListView: View {
    var searchterm: String
    @StateObject var googleNewsVM = GoogleNewsViewModel()
    @AppStorage("isEnglish") private var isEnglish = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var showSafari = false
    
    @State var urlString = ""
    
    var body: some View {
      
        ScrollView{
            VStack(alignment: .leading, spacing: 10) {
                ForEach(googleNewsVM.news, id: \.self) { item in
                    Button {
                        self.urlString = item.link
                        self.showSafari.toggle()
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(item.source)
                                Spacer()
                            }
                            .foregroundColor(.orange)

                            Text(item.title)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        .font(.callout.bold())
                        .foregroundColor(.primary)
                        .padding(.vertical, 3)
                    }
                }
                .sheet(isPresented: $showSafari){
                    SafariView(url: URL(string: self.urlString)!)
                }
            }
        }
        .onAppear {
            print(self.searchterm)
            if isEnglish {
                googleNewsVM.loadUSGoogleNews(query: searchterm)
            } else {
                googleNewsVM.loadKRGoogleNews(query: searchterm)
            }
        }
    }
}

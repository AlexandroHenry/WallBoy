//
//  TimeSeriesViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import Foundation

class TimeSeriesViewModel: ObservableObject {
    @Published var currentStock = [TimeSeries]()
    
    func fetch(symbol: String, period: String, interval: String) {
        
        //MARK: 날짜 및 주기 선택
//        period : str
//            Valid periods: 1d,5d,1mo,3mo,6mo,1y,2y,5y,10y,ytd,max Either Use period parameter or use start and end
//        interval : str
//            Valid intervals: 1m,2m,5m,15m,30m,60m,90m,1h,1d,5d,1wk,1mo,3mo Intraday data cannot extend last 60 days
//        start: str
//            Download start date string (YYYY-MM-DD) or _datetime. Default is 1900-01-01
//        end: str
//            Download end date string (YYYY-MM-DD) or _datetime. Default is now
        
        
        let urlString = "http://131.186.28.79/timeseries/symbol=\(symbol)&period=\(period)&interval=\(interval)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let stsDaily = try JSONDecoder().decode([TimeSeries].self, from: data)
                
                DispatchQueue.main.sync {
                    self!.currentStock = stsDaily
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

//MARK: TimeSeries Model
struct TimeSeries: Codable, Hashable,Identifiable {
    let id: String
    let date: String
    let open, high, low, close: Double
    let volume: Int
    var convertedDate: Date {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")as TimeZone?
        
        let convertedDate: Date = dateFormatter.date(from: date)!
        return convertedDate
    }
}


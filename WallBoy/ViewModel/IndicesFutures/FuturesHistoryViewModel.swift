//
//  FuturesHistoryViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/06.
//

import Foundation

class FuturesHistoryViewModel: ObservableObject {
    
    @Published var futuresHistory = [IndicesFuturesHistory]()
    
    func fetchFuturesHistory(symbol: String) {
        print("fetchFuturesHistory init")
        var urlString = "http://131.186.28.79/indices/history/symbol=\(symbol)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            print("fetchFuturesHistory URLSession Started")
            
            guard let data = data, error == nil else {
                return
            }
            print("fetchFuturesHistory Data Valid")
            do {
                let stsDaily = try JSONDecoder().decode([IndicesFuturesHistory].self, from: data)
                
                print("fetchFuturesHistory JsonDecoded")
                
                DispatchQueue.main.sync {
                    self!.futuresHistory = stsDaily
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchFuturesPeriodHistory(symbol: String, period: String) {
        var urlString = "http://131.186.28.79/futures/graph/symbol=\(symbol)&period=\(period)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            print("fetchFuturesHistory URLSession Started")
            
            guard let data = data, error == nil else {
                return
            }
            print("fetchFuturesHistory Data Valid")
            do {
                let stsDaily = try JSONDecoder().decode([IndicesFuturesHistory].self, from: data)
                
                print("fetchFuturesHistory JsonDecoded")
                
                DispatchQueue.main.sync {
                    self!.futuresHistory = stsDaily
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct IndicesFuturesHistory: Codable, Hashable {
    let date: String
    let adjClose: Double
}

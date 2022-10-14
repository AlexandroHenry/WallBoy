//
//  DailyStockViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import Foundation

class DailyStockViewModel: ObservableObject {
    @Published var dailyStock = [DailyStock]()
    
    func fetch(symbol: String) {
        
        let urlString = "http://131.186.28.79/dailyStock/symbol=\(symbol)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let stsDaily = try JSONDecoder().decode([DailyStock].self, from: data)
                
                DispatchQueue.main.sync {
                    self!.dailyStock = stsDaily
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

// MARK: DailyStock Model
struct DailyStock: Codable, Hashable, Identifiable {
    let id: String
    let date: String
    let open, high, low, close: Double
    let adjclose: Double
    let volume: Int

    var convertedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let convertedDate: Date = dateFormatter.date(from: date)!
        return convertedDate
    }
}


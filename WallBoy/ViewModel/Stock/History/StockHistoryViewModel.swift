//
//  StockPurchaseViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import Foundation

class StockHistoryViewModel: ObservableObject {
    @Published var stockHistory = [StockHistory]()

    // Stock History 로 보내야 할 것
    func fetchHistory(userId: String, action: String, symbol: String, price: String, quantity: String) {
        
        let urlString = "http://131.186.28.79/stocktransaction/owner=\(userId)&action=\(action)&symbol=\(symbol)&price=\(price)&quantity=\(quantity)"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
        }

        task.resume()
    }
    
    // stock History 받을 것
    func fetchHistoryLoading(owner: String) {
        
        let urlString = "http://131.186.28.79/stocktransaction/owner=\(owner)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let stockHistory = try JSONDecoder().decode([StockHistory].self, from: data)
                
                DispatchQueue.main.sync {
                    self!.stockHistory = stockHistory
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct StockHistory: Codable, Identifiable {
    let id: String
    let date: String
    let owner, action, symbol, price: String
    let quantity: String
}



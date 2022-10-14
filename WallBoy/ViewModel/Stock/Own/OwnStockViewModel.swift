//
//  OwnStockViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import Foundation

class OwnStockViewModel: ObservableObject {
    @Published var ownStock = [OwnStock]()

    // Stock History 로 보내야 할 것
    func fetchBuy(userId: String, symbol: String, price: String, quantity: String) {
        
        let urlString = "http://131.186.28.79/stocktransaction/buy/owner=\(userId)&symbol=\(symbol)&price=\(price)&quantity=\(quantity)"
        
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
    
    func fetchSell(userId: String, symbol: String, price: String, quantity: String) {
        
        let urlString = "http://131.186.28.79/stocktransaction/sell/owner=\(userId)&symbol=\(symbol)&price=\(price)&quantity=\(quantity)"
        
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
    
    func fetchLoad(userId: String) {
        let urlString = "http://131.186.28.79/stocktransaction/own/owner=\(userId)"

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let ownStock = try JSONDecoder().decode([OwnStock].self, from: data)

                DispatchQueue.main.sync {
                    self!.ownStock = ownStock
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct OwnStock: Codable, Hashable {
    let owner, symbol, price: String
    let quantity: String
}



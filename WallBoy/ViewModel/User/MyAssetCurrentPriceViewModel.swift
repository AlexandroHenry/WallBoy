//
//  MyAssetCurrentPriceViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/04.
//

import Foundation

class MyStockCurrentPriceViewModel: ObservableObject {
    @Published var mystockcurrentprice = [MyAssetCurrentPrice]()
    
    // Stock History 로 보내야 할 것
    func fetchUserStocks(userId: String) {
        let urlString = "http://131.186.28.79/myStockCurrentPrice/owner=\(userId)"

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let mystockcurrentprice = try JSONDecoder().decode([MyAssetCurrentPrice].self, from: data)
                DispatchQueue.main.sync {
                    self!.mystockcurrentprice = mystockcurrentprice
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct MyAssetCurrentPrice: Codable {
    let symbol: String
    let adjclose: Double
    
    init() {
        symbol = "AAPL"
        adjclose = 10
    }
}

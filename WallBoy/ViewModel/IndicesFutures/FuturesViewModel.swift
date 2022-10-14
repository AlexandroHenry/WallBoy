//
//  FuturesViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/05.
//

import Foundation

class FuturesViewModel: ObservableObject {
    
    @Published var futures = [IndicesFutures]()
    
    func fetchFutures(symbol: String) {
        
        let urlString = "http://131.186.28.79/indices/symbol=\(symbol)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let stsDaily = try JSONDecoder().decode([IndicesFutures].self, from: data)
                
                DispatchQueue.main.sync {
                    self!.futures = stsDaily
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}

struct IndicesFutures: Codable, Hashable {
    let name: String
    let nameKR: String
    let symbol: String
    let unit: String
    let regularMarketPrice: Double
    let type: String
}

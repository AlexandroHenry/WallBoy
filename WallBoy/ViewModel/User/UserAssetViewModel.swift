//
//  UserAssetViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/10/03.
//

import Foundation

class UserAssetViewModel: ObservableObject {
    @Published var userAsset = [Myassethistory]()
    
    // Stock History 로 보내야 할 것
    func fetchUserAsset(userId: String) {
        let urlString = "http://131.186.28.79/myasset/id=\(userId)"

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let userAsset = try JSONDecoder().decode([Myassethistory].self, from: data)
                print(userAsset)
                DispatchQueue.main.sync {
                    self!.userAsset = userAsset
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct Myassethistory: Codable, Hashable {
    let cash, stock, updatedAt: String
    
    init() {
        cash = "0"
        stock = "0"
        updatedAt = "2022-10-03 23:53:03.999000"
    }
}


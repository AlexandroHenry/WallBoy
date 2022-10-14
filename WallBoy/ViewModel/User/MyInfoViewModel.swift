//
//  MyInfoViewModel.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/21.
//

import Foundation

class MyInfoViewModel: ObservableObject {
    @Published var userInfo = UserInfo()
    
    // Stock History 로 보내야 할 것
    func fetchUserInfo(userId: String) {
        let urlString = "http://131.186.28.79/userInfo/id=\(userId)"

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)

                DispatchQueue.main.sync {
                    self!.userInfo = userInfo
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct UserInfo: Codable, Hashable {
    let result: Result
    
    init() {
        result = Result(resultID: "", email: "", nickname: "", cash: "", imageURL: "")
    }
}

// MARK: - Result
struct Result: Codable,Hashable {
    let resultID: String
    let email, nickname, cash: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case resultID = "id"
        case email, nickname, cash, imageURL
    }
}

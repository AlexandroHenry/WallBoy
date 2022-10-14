//
//  ModelData.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/09/20.
//

import SwiftUI
import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var stockInfo: [StockInformation] = load("stock_info.json")
    @Published var sp500list: [SP500List] = load("sp500list.json")
    @Published var krxlist: [StockKRDetail] = load("stock_info_KRX.json")
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
}

struct StockKRDetail: Hashable, Codable {
    var symbol: String
    var market: String
    var name: String
    var sector: String
    var industry: String
    var region: String
    var webpage: String
    var marketCap: Int
    var volume: Int
    
    init() {
        symbol = ""
        market = ""
        name = ""
        sector = ""
        industry = ""
        region = ""
        webpage = ""
        marketCap = 0
        volume = 0
    }
}

struct StockInformation: Codable, Hashable {
    let symbol, name, nameKR, sector: String
    let industry: String
    let website: String
    let country: String
    let marketCap: Int
    let zip, descriptionEng, descriptionKR: String
    let logoURL: String
    let market: String

    enum CodingKeys: String, CodingKey {
        case symbol, name, nameKR, sector, industry, website, country, marketCap, zip
        case descriptionEng = "description"
        case descriptionKR, logoURL, market
    }

    init() {
        symbol = ""
        name = ""
        nameKR = ""
        sector = ""
        industry = ""
        website = ""
        country = ""
        marketCap = 0
        zip = ""
        descriptionEng = ""
        descriptionKR = ""
        logoURL = ""
        market = ""
    }
}

struct SP500List: Codable, Hashable {
    let symbol: String
    let name: String
    let sector: String
    let industry: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "Symbol"
        case name = "Name"
        case sector = "Sector"
        case industry = "Industry"
    }
}

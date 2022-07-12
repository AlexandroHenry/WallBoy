//
//  Card.swift
//  WallBoy
//
//  Created by Seungchul Ha on 2022/07/12.
//

import SwiftUI

struct Card: Identifiable {
    
    var id = UUID().uuidString
    var cardColor: Color
    var date: String = ""
    var title: String
    
}


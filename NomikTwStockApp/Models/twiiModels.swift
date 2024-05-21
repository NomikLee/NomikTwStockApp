//
//  twiiModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/21.
//

import Foundation

struct TwiiRespose: Codable {
    let date: String
    let symbol: String
    let data: [TwiiData]
}

struct TwiiData: Codable {
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}

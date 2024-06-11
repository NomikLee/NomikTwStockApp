//
//  candleModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/6/9.
//

import Foundation

struct CandleRespose: Codable {
    let symbol: String
    let type: String
    let exchange: String
    let market: String
    let timeframe: String
    let data: [CandleData]
}

struct CandleData: Codable {
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}


//
//  MarketDataModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import Foundation

struct MarketDataResponse: Codable {
    let date: String
    let time: String
    let market: String
    let data: [EquityData]
}

struct EquityData: Codable {
    let type: String
    let symbol: String
    let name: String
    let openPrice: Double?
    let highPrice: Double?
    let lowPrice: Double?
    let closePrice: Double?
    let change: Double
    let changePercent: Double
    let tradeVolume: Double
}

//
//  QuoteSingleModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import Foundation

struct QuoteSingleModels: Codable {
    let date: String
    let symbol: String
    let name: String
    let openPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let closePrice: Double
    let avgPrice: Double
    let change: Double
    let changePercent: Double
    let amplitude: Double
    let bids: [PriceSize]
    let asks: [PriceSize]
    let total: Total
    let lastUpdated: Double
}

struct PriceSize: Codable {
    let price: Double
    let size: Double
}

struct Total: Codable {
    let tradeValue: Double
    let tradeVolume: Double
    let tradeVolumeAtBid: Double
    let tradeVolumeAtAsk: Double
    let transaction: Double
    let time: Double
}

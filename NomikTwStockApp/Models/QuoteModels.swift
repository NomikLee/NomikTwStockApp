//
//  QuoteModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import Foundation

struct QuoteModels: Codable {
    let date: String
    let type: String
    let exchange: String
    let market: String
    let symbol: String
    let name: String
    let referencePrice: Double
    let previousClose: Double
    let openPrice: Double
    let openTime: Double
    let highPrice: Double
    let highTime: Double
    let lowPrice: Double
    let lowTime: Double
    let closePrice: Double
    let closeTime: Double
    let avgPrice: Double
    let change: Double
    let changePercent: Double
    let amplitude: Double
    let lastPrice: Double
    let lastSize: Double
    let bids: [PriceSize]
    let asks: [PriceSize]
    let total: Total
    let lastTrade: TradeTrial
    let lastTrial: TradeTrial
    let isClose: Bool
    let serial: Double
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
        
struct TradeTrial: Codable{
    let bid: Double
    let ask: Double
    let price: Double
    let size: Double
    let time: Double
    let serial: Double
}


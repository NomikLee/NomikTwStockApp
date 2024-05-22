//
//  MoversDownModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/22.
//

import Foundation

struct MoversDownRespose: Codable {
    let date: String
    let data: [MoversDownData]
}

struct MoversDownData: Codable {
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

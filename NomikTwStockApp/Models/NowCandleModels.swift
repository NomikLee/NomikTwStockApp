//
//  NowCandleModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/12/5.
//

import Foundation

struct NowCandleRespose: Codable {
    let date: String
    let symbol: String
    let data: [NowCandle]
}

struct NowCandle: Codable {
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    let average: Double
}

//
//  tickersModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/6/12.
//

import Foundation

struct TickersResponse: Codable {
    let date: String
    let type: String
    let exchange: String
    let isNormal: Bool?
    let data: [TickersListDatas]?
}

struct TickersListDatas: Codable {
    let symbol: String?
    let name: String?
}

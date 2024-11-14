//
//  Constants.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import Foundation

struct Constants {
    static let apiKey = ""
    static let baseURL = "https://api.fugle.tw/marketdata/v1.0/stock"
}

enum Http {
    
    enum Headers: String {
        case apiKey = "X-API-KEY"
    }
    
    enum Endpoints {
        case tickers
        case quotes
        case movers
        case actives
        case ticker(String)
        case quote(String)
        case candles(String)
        case trades(String)
        case volumes(String)
        case hcandles(String)
        case hstats(String)
        
        func valueEndpoints() -> String {
            switch self {
            case .tickers:
                return "/intraday/tickers"
            case .quotes:
                return "/snapshot/quotes/TSE"
            case .movers:
                return "/snapshot/movers/TSE"
            case .actives:
                return "/snapshot/actives/TSE"
            case .ticker(let stockNum):
                return "/intraday/ticker/\(stockNum)"
            case .quote(let stockNum):
                return "/intraday/quote/\(stockNum)"
            case .candles(let stockNum):
                return "/intraday/candles/\(stockNum)"
            case .trades(let stockNum):
                return "/intraday/trades/\(stockNum)"
            case .volumes(let stockNum):
                return "/intraday/volumes/\(stockNum)"
            case .hcandles(let stockNum):
                return "/historical/candles/\(stockNum)"
            case .hstats(let stockNum):
                return "/historical/stats/\(stockNum)"
            }
        }
    }
}



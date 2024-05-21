//
//  APIService.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    func twiiCall(completion: @escaping ((Result<TwiiRespose, Error>) -> Void)) {
        let urlNum = Http.Endpoints.candles("IX0001")
        let url = URL(string: Constants.baseURL + urlNum.valueEndpoints())
        var request = URLRequest(url: url!)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let twiiDatas = try JSONDecoder().decode(TwiiRespose.self, from: data)
                completion(.success(twiiDatas))
            } catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    func quotesCall(completion: @escaping ((Result<MarketDataResponse, Error>) -> Void)) {
        let url = URL(string: Constants.baseURL + Http.Endpoints.quotes.valueEndpoints())
        var request = URLRequest(url: url!)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let marketData = try JSONDecoder().decode(MarketDataResponse.self, from: data)
                completion(.success(marketData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
}


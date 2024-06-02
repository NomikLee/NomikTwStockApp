//
//  APIService.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import Foundation

class APIService {
    
    // 確保只有一個 APIService 實例
    static let shared = APIService()
    
    // TWII API 請求
    func twiiCall(completion: @escaping ((Result<TwiiRespose, Error>) -> Void)) {
        // 組合 URL
        let urlNum = Http.Endpoints.candles("IX0001")
        let url = URL(string: Constants.baseURL + urlNum.valueEndpoints())
        
        // 構建 URLRequest
        var request = URLRequest(url: url!)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        // 發送網路請求
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            // 檢查是否有錯誤或無數據返回
            guard let data = data, error == nil else { return }
            do {
                // 將返回的數據解碼成 TwiiRespose 類型
                let twiiDatas = try JSONDecoder().decode(TwiiRespose.self, from: data)
                completion(.success(twiiDatas))
            } catch {
                completion(.failure(error))
            }
        }
        // 開始任務
        tast.resume()
    }
    
    // 上漲股票 API 請求
    func moversUpCall(completion: @escaping ((Result<MoversUPRespose, Error>) -> Void)) {
        // 組合 URL
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.movers.valueEndpoints())
        
        // 添加查詢參數
        let queryItem = [
            URLQueryItem(name: "direction", value: "up"),
            URLQueryItem(name: "change", value: "value")
        ]
        urlComponents?.queryItems = queryItem
        
        // 確保 URL 有效
        guard let url = urlComponents?.url else { return }
        
        // 構建 URLRequest
        var request = URLRequest(url: url)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        // 發送網路請求
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            // 檢查是否有錯誤或無數據返回
            guard let data = data, error == nil else { return }
            do {
                // 將返回的數據解碼成 MoversUPRespose 類型
                let moversUPData = try JSONDecoder().decode(MoversUPRespose.self, from: data)
                completion(.success(moversUPData))
            }catch {
                completion(.failure(error))
            }
        }
        // 開始任務
        tast.resume()
    }
    
    // 下跌股票 API 請求
    func moversDownCall(completion: @escaping ((Result<MoversDownRespose, Error>) -> Void)) {
        // 組合 URL
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.movers.valueEndpoints())
        
        // 添加查詢參數
        let queryItem = [
            URLQueryItem(name: "direction", value: "down"),
            URLQueryItem(name: "change", value: "value")
        ]
        urlComponents?.queryItems = queryItem
        
        // 確保 URL 有效
        guard let urlComponents = urlComponents?.url else { return }
        
        // 構建 URLRequest
        var request = URLRequest(url: urlComponents)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        // 發送網路請求
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            // 檢查是否有錯誤或無數據返回
            guard let data = data, error == nil else { return }
            do {
                // 將返回的數據解碼成 MoversDownRespose 類型
                let moversDownData = try JSONDecoder().decode(MoversDownRespose.self, from: data)
                completion(.success(moversDownData))
            }catch {
                completion(.failure(error))
            }
        }
        // 開始任務
        tast.resume()
    }
    
    // 交易量 API 請求
    func volumesCall(completion: @escaping ((Result<VolumesRespose, Error>) -> Void)) {
        // 組合 URL
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.actives.valueEndpoints())
        
        // 添加參數
        let queryItem = [
            URLQueryItem(name: "trade", value: "volume")
        ]
        urlComponents?.queryItems = queryItem
        
        // 確保 URL 有效
        guard let urlComponents = urlComponents?.url else { return }
        
        var request = URLRequest(url: urlComponents)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        // 發送網路請求
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            // 檢查是否有錯誤或無數據返回
            guard let data = data, error == nil else { return }
            do {
                // 將返回的數據解碼成 VolumesRespose 類型
                let volumesData = try JSONDecoder().decode(VolumesRespose.self, from: data)
                completion(.success(volumesData))
            }catch {
                completion(.failure(error))
            }
        }
        // 開始任務
        tast.resume()
    }
    
    // 市場數據 API 請求
    func quotesCall(completion: @escaping ((Result<MarketDataResponse, Error>) -> Void)) {
        // 組合 URL
        let url = URL(string: Constants.baseURL + Http.Endpoints.quotes.valueEndpoints())
        
        // 構建 URLRequest
        var request = URLRequest(url: url!)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        // 發送網路請求
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            // 檢查是否有錯誤或無數據返回
            guard let data = data, error == nil else { return }
            do {
                // 將返回的數據解碼成 MarketDataResponse 類型
                let marketData = try JSONDecoder().decode(MarketDataResponse.self, from: data)
                completion(.success(marketData))
            }catch {
                completion(.failure(error))
            }
        }
        // 開始任務
        tast.resume()
    }
    
    // 懲罰公告 API 請求
    func punishCall(completion: @escaping ((Result<[Punish], Error>) -> Void)) {
        // 組合 URL
        let url = URL(string: "https://openapi.twse.com.tw/v1/announcement/punish")
        
        // 構建 URLRequest 並設置頭部字段
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Mon, 26 Jul 1997 05:00:00 GMT", forHTTPHeaderField: "If-Modified-Since")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        // 發送網路請求
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            // 檢查是否有錯誤或無數據返回
            guard let data = data, error == nil else { return }
            
            do {
                // 將返回的數據解碼成 [Punish] 類型
                let punishData = try JSONDecoder().decode([Punish].self, from: data)
                completion(.success(punishData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    // 紀錄轉讓公告 API 請求
    func notetransCall(completion: @escaping ((Result<[Notetrans], Error>) -> Void)) {
        // 組合 URL
        let url = URL(string: "https://openapi.twse.com.tw/v1/announcement/notetrans")
        
        // 構建 URLRequest 並設置頭部字段
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Mon, 26 Jul 1997 05:00:00 GMT", forHTTPHeaderField: "If-Modified-Since")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        // 發送網路請求
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            // 檢查是否有錯誤或無數據返回
            guard let data = data, error == nil else { return }
            
            do {
                // 將返回的數據解碼成 [Notetrans] 類型
                let notetransData = try JSONDecoder().decode([Notetrans].self, from: data)
                completion(.success(notetransData))
            }catch {
                completion(.failure(error))
            }
        }
        // 開始任務
        tast.resume()
    }
}



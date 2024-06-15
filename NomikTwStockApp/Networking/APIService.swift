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
        
        let urlNum = Http.Endpoints.candles("IX0001")
        let url = URL(string: Constants.baseURL + urlNum.valueEndpoints())
        
        var request = URLRequest(url: url!)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        // 發送網路請求
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
    
    // 上漲股票 API 請求
    func moversUpCall(completion: @escaping ((Result<MoversUPRespose, Error>) -> Void)) {
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.movers.valueEndpoints())
        
        let queryItem = [
            URLQueryItem(name: "direction", value: "up"),
            URLQueryItem(name: "change", value: "value")
        ]
        urlComponents?.queryItems = queryItem
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let moversUPData = try JSONDecoder().decode(MoversUPRespose.self, from: data)
                completion(.success(moversUPData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    // 下跌股票 API 請求
    func moversDownCall(completion: @escaping ((Result<MoversDownRespose, Error>) -> Void)) {
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.movers.valueEndpoints())
        
        let queryItem = [
            URLQueryItem(name: "direction", value: "down"),
            URLQueryItem(name: "change", value: "value")
        ]
        urlComponents?.queryItems = queryItem
        
        guard let urlComponents = urlComponents?.url else { return }
        
        var request = URLRequest(url: urlComponents)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let moversDownData = try JSONDecoder().decode(MoversDownRespose.self, from: data)
                completion(.success(moversDownData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    // 交易量 API 請求
    func volumesCall(completion: @escaping ((Result<VolumesRespose, Error>) -> Void)) {
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.actives.valueEndpoints())
        
        let queryItem = [
            URLQueryItem(name: "trade", value: "volume")
        ]
        urlComponents?.queryItems = queryItem
        guard let urlComponents = urlComponents?.url else { return }
        
        var request = URLRequest(url: urlComponents)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let volumesData = try JSONDecoder().decode(VolumesRespose.self, from: data)
                completion(.success(volumesData))
            }catch {
                completion(.failure(error))
            }
        }
        
        tast.resume()
    }
    
    // 市場數據 API 請求
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
    
    // 處置公告 API 請求
    func punishCall(completion: @escaping ((Result<[Punish], Error>) -> Void)) {
        let url = URL(string: "https://openapi.twse.com.tw/v1/announcement/punish")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Mon, 26 Jul 1997 05:00:00 GMT", forHTTPHeaderField: "If-Modified-Since")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let punishData = try JSONDecoder().decode([Punish].self, from: data)
                completion(.success(punishData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    // 注意公告 API 請求
    func notetransCall(completion: @escaping ((Result<[Notetrans], Error>) -> Void)) {
        let url = URL(string: "https://openapi.twse.com.tw/v1/announcement/notetrans")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Mon, 26 Jul 1997 05:00:00 GMT", forHTTPHeaderField: "If-Modified-Since")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let notetransData = try JSONDecoder().decode([Notetrans].self, from: data)
                completion(.success(notetransData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    // 殖利率 本益比 淨值比 API 請求
    func peDyPbCall(completion: @escaping ((Result<[PeDyPbModels], Error>) -> Void)) {
        let url = URL(string: "https://openapi.twse.com.tw/v1/exchangeReport/BWIBBU_ALL")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Mon, 26 Jul 1997 05:00:00 GMT", forHTTPHeaderField: "If-Modified-Since")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let peDyPbData = try JSONDecoder().decode([PeDyPbModels].self, from: data)
                completion(.success(peDyPbData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }

    // 個別股票 API 請求
    func quoteSingleCall(symbolCode: String, completion: @escaping((Result<QuoteSingleModels, Error>) -> Void)) {
        let url = URL(string: Constants.baseURL + Http.Endpoints.quote(symbolCode).valueEndpoints())
        
        var request = URLRequest(url: url!)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let quoteData = try JSONDecoder().decode(QuoteSingleModels.self, from: data)
                completion(.success(quoteData))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    // k棒 API 請求
    func candleCall(symbolCode: String, timeframe: String, completion: @escaping((Result<CandleRespose, Error>) -> Void)) {
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.hcandles(symbolCode).valueEndpoints())
        
        let queryItem = [
            URLQueryItem(name: "timeframe", value: timeframe),
            URLQueryItem(name: "fields", value: "open,high,low,close,volume"),
            URLQueryItem(name: "from", value: "2024-03-01")
        ]
        
        urlComponents?.queryItems = queryItem
        
        guard let urlComponents = urlComponents?.url else { return }
        
        var request = URLRequest(url: urlComponents)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let candleDatas = try JSONDecoder().decode(CandleRespose.self, from: data)
                completion(.success(candleDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    // 搜尋欄 API 請求
    func tickersCall(completion: @escaping((Result<TickersResponse, Error>) -> Void)) {
        var urlComponents = URLComponents(string: Constants.baseURL + Http.Endpoints.tickers.valueEndpoints())
        
        let queryItem = [
            URLQueryItem(name: "type", value: "EQUITY"),
            URLQueryItem(name: "exchange", value: "TWSE")
        ]
        
        urlComponents?.queryItems = queryItem
        
        guard let urlComponents = urlComponents?.url else { return }
        
        var request = URLRequest(url: urlComponents)
        request.setValue(Constants.apiKey, forHTTPHeaderField: Http.Headers.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let tickersDatas = try JSONDecoder().decode(TickersResponse.self, from: data)
                completion(.success(tickersDatas))
            }catch {
                print("Error: JSON decoding failed with error - \(error)")
                completion(.failure(error))
            }
        }
        tast.resume()
    }
}



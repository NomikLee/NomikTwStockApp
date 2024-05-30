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
    
}


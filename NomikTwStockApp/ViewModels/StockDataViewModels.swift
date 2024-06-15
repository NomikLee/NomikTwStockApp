//
//  StockDataViewModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/22.
//

import Foundation

class StockDataViewModels {
    
    // 定義變量以保存 API 請求的結果
    var moversUPData: MoversUPRespose?
    var moversDOWNData: MoversDownRespose?
    var volumesData: VolumesRespose?
    var punishData: [Punish] = []
    var notetransData: [Notetrans] = []
    
    // 獲取上漲排行股票數據
    func GetMoversUp(completion: @escaping((Result<MoversUPRespose, Error>) -> Void)) {
        APIService.shared.moversUpCall { [weak self] result in
            switch result {
            case .success(let moversUpData):
                self?.moversUPData = moversUpData
                completion(.success(moversUpData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 獲取下跌排行股票數據
    func GetMoversDown(completion: @escaping((Result<MoversDownRespose, Error>) -> Void)) {
        APIService.shared.moversDownCall { [weak self] result in
            switch result {
            case .success(let moversDownData):
                self?.moversDOWNData = moversDownData
                completion(.success(moversDownData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 獲取交易量排行數據
    func GetVolumes(completion: @escaping((Result<VolumesRespose, Error>) -> Void)) {
        APIService.shared.volumesCall { [weak self] result in
            switch result {
            case .success(let volumesData):
                self?.volumesData = volumesData
                completion(.success(volumesData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 獲取處置公告數據
    func GetPunish(completion: @escaping((Result<[Punish], Error>) -> Void)) {
        APIService.shared.punishCall { [weak self] result in
            switch result {
            case .success(let punishDataJoin):
                self?.punishData = punishDataJoin
                completion(.success(punishDataJoin))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 獲取注意公告數據
    func GetNotetrans(completion: @escaping((Result<[Notetrans], Error>) -> Void)) {
        APIService.shared.notetransCall { [weak self] result in
            switch result {
            case .success(let notetransDataJoin):
                self?.notetransData = notetransDataJoin
                completion(.success(notetransDataJoin))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 獲取個股股票數據
    func GetQuoteSingle(symbolCode: String, completion: @escaping((Result<QuoteSingleModels, Error>) -> Void)) {
        APIService.shared.quoteSingleCall(symbolCode: symbolCode) { [weak self] result in
            switch result {
            case .success(let quoteSingle):
                completion(.success(quoteSingle))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 獲取殖利率 本益比 淨值比數據
    func GetPeDyPbCall(completion: @escaping((Result<[PeDyPbModels], Error>) -> Void)) {
        APIService.shared.peDyPbCall { [weak self] result in
            switch result {
            case .success(let peDyPbData):
                completion(.success(peDyPbData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 獲取k棒數據
    func GetCandle(symbolCode: String, timeframe: String, completion: @escaping((Result<CandleRespose, Error>) -> Void)) {
        APIService.shared.candleCall(symbolCode: symbolCode, timeframe: timeframe) { [weak self] result in
            switch result {
            case .success(let candleDatas):
                completion(.success(candleDatas))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //獲取搜尋欄數據
    func GetTickers(completion: @escaping((Result<TickersResponse, Error>) -> Void)) {
        APIService.shared.tickersCall { [weak self] result in
            switch result {
            case .success(let tickersCallData):
                completion(.success(tickersCallData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


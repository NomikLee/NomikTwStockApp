//
//  StockDataViewModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/22.
//

import Foundation

class StockDataViewModels: ObservableObject {
    @Published var moversUPData: MoversUPRespose?
    @Published var moversDOWNData: MoversDownRespose?
    @Published var volumesData: VolumesRespose?
    
    // 獲取上漲排行股票數據
    func GetMoversUp() {
        APIServiceManager.shared.moversUpCall { [weak self] result in
            switch result {
            case .success(let upDatas):
                self?.moversUPData = upDatas
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 獲取下跌排行股票數據
    func GetMoversDown() {
        APIServiceManager.shared.moversDownCall { [weak self] result in
            switch result {
            case .success(let downDatas):
                self?.moversDOWNData = downDatas
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 獲取交易量排行數據
    func GetVolumes() {
        APIServiceManager.shared.volumesCall { [weak self] result in
            switch result {
            case .success(let volumeDatas):
                self?.volumesData = volumeDatas
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 獲取個股股票數據
    func GetQuoteSingle(symbolCode: String, completion: @escaping((Result<QuoteSingleModels, Error>) -> Void)) {
        APIServiceManager.shared.quoteSingleCall(symbolCode: symbolCode) { [weak self] result in
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
        APIServiceManager.shared.peDyPbCall { [weak self] result in
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
        APIServiceManager.shared.candleCall(symbolCode: symbolCode, timeframe: timeframe) { [weak self] result in
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
        APIServiceManager.shared.tickersCall { [weak self] result in
            switch result {
            case .success(let tickersCallData):
                completion(.success(tickersCallData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


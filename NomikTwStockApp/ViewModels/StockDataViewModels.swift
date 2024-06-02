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
        // 調用 APIService 來獲取上漲股票數據
        APIService.shared.moversUpCall { [weak self] result in
            switch result {
            case .success(let moversUpData):
                // 成功時保存數據並調用完成處理程序
                self?.moversUPData = moversUpData
                completion(.success(moversUpData))
            case .failure(let error):
                // 失敗時調用完成處理程序並返回錯誤
                completion(.failure(error))
            }
        }
    }
    
    // 獲取下跌排行股票數據
    func GetMoversDown(completion: @escaping((Result<MoversDownRespose, Error>) -> Void)) {
        // 調用 APIService 來獲取下跌股票數據
        APIService.shared.moversDownCall { [weak self] result in
            switch result {
            case .success(let moversDownData):
                // 成功時保存數據並調用完成處理程序
                self?.moversDOWNData = moversDownData
                completion(.success(moversDownData))
            case .failure(let error):
                // 失敗時調用完成處理程序並返回錯誤
                completion(.failure(error))
            }
        }
    }
    
    // 獲取交易量排行數據
    func GetVolumes(completion: @escaping((Result<VolumesRespose, Error>) -> Void)) {
        // 調用 APIService 來獲取交易量數據
        APIService.shared.volumesCall { [weak self] result in
            switch result {
            case .success(let volumesData):
                // 成功時保存數據並調用完成處理程序
                self?.volumesData = volumesData
                completion(.success(volumesData))
            case .failure(let error):
                // 失敗時調用完成處理程序並返回錯誤
                completion(.failure(error))
            }
        }
    }
    
    // 獲取處置公告數據
    func GetPunish(completion: @escaping((Result<[Punish], Error>) -> Void)) {
        // 調用 APIService 來獲取懲罰公告數據
        APIService.shared.punishCall { [weak self] result in
            switch result {
            case .success(let punishDataJoin):
                // 成功時保存數據並調用完成處理程序
                self?.punishData = punishDataJoin
                completion(.success(punishDataJoin))
            case .failure(let error):
                // 失敗時調用完成處理程序並返回錯誤
                completion(.failure(error))
            }
        }
    }
    
    // 獲取注意公告數據
    func GetNotetrans(completion: @escaping((Result<[Notetrans], Error>) -> Void)) {
        // 調用 APIService 來獲取紀錄轉讓公告數據
        APIService.shared.notetransCall { [weak self] result in
            switch result {
            case .success(let notetransDataJoin):
                // 成功時保存數據並調用完成處理程序
                self?.notetransData = notetransDataJoin
                completion(.success(notetransDataJoin))
            case .failure(let error):
                // 失敗時調用完成處理程序並返回錯誤
                completion(.failure(error))
            }
        }
    }
}


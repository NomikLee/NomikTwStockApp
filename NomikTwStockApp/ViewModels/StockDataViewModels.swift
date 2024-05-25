//
//  StockDataViewModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/22.
//

import Foundation

class StockDataViewModels {
    
    var moversUPData: MoversUPRespose?
    var moversDOWNData: MoversDownRespose?
    var volumesData: VolumesRespose?
    
    func GetMoversUp(completion: @escaping((Result<MoversUPRespose, Error>) -> Void)) {
        APIService.shared.moversUpCall {[weak self] result in
            switch result {
            case .success(let moversUpData):
                self?.moversUPData = moversUpData
                completion(.success(moversUpData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func GetMoversDown(completion: @escaping((Result<MoversDownRespose, Error>) -> Void)) {
        APIService.shared.moversDownCall {[weak self] result in
            switch result {
            case .success(let moversDownData):
                self?.moversDOWNData = moversDownData
                completion(.success(moversDownData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func GetVolumes(completion: @escaping((Result<VolumesRespose, Error>) -> Void)) {
        APIService.shared.volumesCall {[weak self] result in
            switch result {
            case .success(let volumesData):
                self?.volumesData = volumesData
                completion(.success(volumesData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
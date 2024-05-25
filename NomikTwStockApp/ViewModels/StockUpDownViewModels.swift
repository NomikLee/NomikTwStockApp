//
//  StockUpDownViewModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/23.
//

import Foundation
import UIKit

final class StockUpDownViewModels: ObservableObject {
    
    @Published var intoChangeValue: Double?
    @Published var colorChange: UIColor = .white
    
    func stockPriceChange() -> String {
        guard let intoChangeValue = intoChangeValue else { return "無資料" }
        
        if intoChangeValue > 9.8 {
            colorChange = .systemRed
            return "漲停"
        }else if intoChangeValue < -9.8{
            colorChange = .systemGreen
            return "跌停"
        }else if intoChangeValue > 0.0 {
            colorChange = .black
            return "上漲"
        }else if intoChangeValue < 0.0 {
            colorChange = .black
            return "下跌"
        }else {
            return "平盤"
        }
    }
}
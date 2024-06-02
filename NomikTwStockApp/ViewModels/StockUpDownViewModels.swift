//
//  StockUpDownViewModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/23.
//

import Foundation
import UIKit

// final 防止該類被繼承
final class StockUpDownViewModels: ObservableObject {
    
    // @Published 將變量標記為可觀察的，當變量改變時會通知視圖進行更新
    @Published var intoChangeValue: Double?
    @Published var colorChange: UIColor = .white
    
    // 根據股票價格變化返回相應的狀態字串
    func stockPriceChange() -> String {
        // 檢查 intoChangeValue 是否為 nil，若為 nil 則返回 "無資料"
        guard let intoChangeValue = intoChangeValue else { return "無資料" }
        
        // 判斷價格變化幅度並設置相應的顏色和狀態
        if intoChangeValue > 9.8 {
            colorChange = .systemRed
            return "漲停"
        } else if intoChangeValue < -9.8 {
            colorChange = .systemGreen
            return "跌停"
        } else if intoChangeValue > 0.0 {
            colorChange = .black
            return "上漲"
        } else if intoChangeValue < 0.0 {
            colorChange = .black
            return "下跌"
        } else {
            return "平盤"
        }
    }
}

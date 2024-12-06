//
//  CalculateViewModels.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/12/2.
//

import Foundation
import Combine

enum enterStringError: Error {
    case pleaseEnterNumber
}

class CalculateViewModels: ObservableObject {
    @Published var totalCalculateData: [CalculateModels] = []
    
    //計算複利的數據
    func calculateTotalValue(initialFundValue: String, newInvestmentValue: String, annualizedRateValue: String, investmentYearStepValue: String) throws {
        guard let initialFundValue = Double(initialFundValue),
        let newInvestmentValue = Double(newInvestmentValue),
        let annualizedRateValue = Double(annualizedRateValue),
              let investmentYearStepValue = Int(investmentYearStepValue) else {
            throw enterStringError.pleaseEnterNumber
        }
        
        totalCalculateData = [] //清空數值
        
        for year in 0...investmentYearStepValue {
            let initialTotel = initialFundValue * pow(1 + (annualizedRateValue / 100), Double(year))
            let newInvestmentTotel = newInvestmentValue * (pow(1 + (annualizedRateValue / 100), Double(year)) - 1) / (annualizedRateValue / 100)
            let totel = initialTotel + newInvestmentTotel
            totalCalculateData.append(CalculateModels(totelYear: year, totelData: totel))
        }
    }
}

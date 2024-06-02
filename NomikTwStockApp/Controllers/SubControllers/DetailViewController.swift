//
//  DetailViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/24.
//

import UIKit
import DGCharts

class DetailViewController: UIViewController {
    
    private let candleStickChartView: CandleStickChartView = {
        let candle = CandleStickChartView()
        candle.translatesAutoresizingMaskIntoConstraints = false
        candle.chartDescription.enabled = false
        candle.legend.enabled = false
        candle.xAxis.labelPosition = .bottom
        candle.xAxis.drawGridLinesEnabled = false
        candle.leftAxis.drawGridLinesEnabled = false
        candle.rightAxis.enabled = false
        
        candle.xAxis.axisMinimum = -1.0
        candle.xAxis.axisMaximum = 15.0
        candle.xAxis.granularity = 1.0
        candle.xAxis.granularityEnabled = true

        candle.leftAxis.axisMinimum = 50.0
        candle.leftAxis.axisMaximum = 200.0
        candle.leftAxis.granularity = 10.0
        candle.leftAxis.granularityEnabled = true
        return candle
    }()
    
    private let buttonTitle: [UIButton] = ["5k", "15k", "60k", "日Ｋ", "週Ｋ", "月Ｋ"].map{ titles in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(titles, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        return button
    }
    
    private lazy var sectionStack: UIStackView = {
        let sectionView = UIStackView(arrangedSubviews: buttonTitle)
        sectionView.translatesAutoresizingMaskIntoConstraints = false
        sectionView.distribution = .equalSpacing
        sectionView.axis = .horizontal
        sectionView.alignment = .center
        return sectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(candleStickChartView)
        view.addSubview(sectionStack)
        
        
        setCandleData()
        configureUI()
    }
    
    func setCandleData() {
        let yVals = [
            CandleChartDataEntry(x: 0.0, shadowH: 120.0, shadowL: 100.0, open: 120.0, close: 120.0),
            CandleChartDataEntry(x: 1.0, shadowH: 160.0, shadowL: 120.0, open: 120.0, close: 150.0),
            CandleChartDataEntry(x: 2.0, shadowH: 100.0, shadowL: 100.0, open: 120.0, close: 100.0),
            CandleChartDataEntry(x: 3.0, shadowH: 99.0, shadowL: 120.0, open: 120.0, close: 150.0),
            CandleChartDataEntry(x: 5.0, shadowH: 70.0, shadowL: 50.0, open: 120.0, close: 150.0),
            CandleChartDataEntry(x: 6.0, shadowH: 120.0, shadowL: 99.0, open: 150.0, close: 99.0),
            CandleChartDataEntry(x: 7.0, shadowH: 200, shadowL: 100, open: 100, close: 300),
            CandleChartDataEntry(x: 8.0, shadowH: 150.0, shadowL: 50.0, open: 99.0, close: 99.0),
            CandleChartDataEntry(x: 9.0, shadowH: 70.0, shadowL: 50.0, open: 120.0, close: 99.0),
            CandleChartDataEntry(x: 10.0, shadowH: 100.0, shadowL: 50.0, open: 100.0, close: 99.0),
            CandleChartDataEntry(x: 11.0, shadowH: 70.0, shadowL: 50.0, open: 120.0, close: 100.0),
        ]

        let set1 = CandleChartDataSet(entries: yVals, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor.systemBackground)
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = .green
        set1.increasingFilled = true
        set1.neutralColor = .white
        set1.drawValuesEnabled = false
        
        candleStickChartView.data = CandleChartData(dataSet: set1)

    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            candleStickChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            candleStickChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            candleStickChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            candleStickChartView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            sectionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sectionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sectionStack.topAnchor.constraint(equalTo: candleStickChartView.bottomAnchor, constant: 20),
        ])
    }
}

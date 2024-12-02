//
//  CalculateViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import UIKit
import DGCharts
import Combine

class CalculateViewController: UIViewController {
    
    // MARK: - Variables
    let padding: CGFloat = 10
    
    private let viewModel = CalculateViewModels()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let initialFundTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "初始資金"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let initialFund: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "請輸入初始資金"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .secondarySystemFill
        textField.layer.cornerRadius = 10
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftView = spacer
        textField.leftViewMode = .always
        return textField
    }()
    
    private let newInvestmentTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "每年新增資金"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let newInvestment: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "請輸入每年投入資金"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .secondarySystemFill
        textField.layer.cornerRadius = 10
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftView = spacer
        textField.leftViewMode = .always
        return textField
    }()
    
    private let annualizedRateTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "年收益率"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let annualizedRate: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "請輸入年收益率"
        textField.keyboardType = .numberPad
        textField.backgroundColor = .secondarySystemFill
        textField.layer.cornerRadius = 10
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftView = spacer
        textField.leftViewMode = .always
        return textField
    }()
    
    private let investmentYearTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "投資年數"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let investmentYearStepText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .secondarySystemFill
        label.textAlignment = .center
        label.text = "1"
        label.layer.cornerRadius = 10
        return label
    }()
    
    private let investmentYearStep: UIStepper = {
        let step = UIStepper()
        step.translatesAutoresizingMaskIntoConstraints = false
        step.minimumValue = 1
        step.maximumValue = 99
        step.stepValue = 1
        step.value = 1
        return step
    }()
    
    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "building.columns.fill"), for: .normal)
        button.backgroundColor = .systemOrange
        button.tintColor = UIColor.black
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .systemBackground
        chartView.extraLeftOffset = 30 // 向左增加偏移量
        chartView.leftAxis.enabled = false // 隱藏左邊Y軸
        chartView.xAxis.labelPosition = .bottom // X 軸底部
        chartView.xAxis.granularity = 1 // X 軸標籤間距
        chartView.highlightPerTapEnabled = false //關閉十字線
        chartView.highlightPerDragEnabled = false //關閉十字線
        chartView.doubleTapToZoomEnabled = false // 啟用雙擊縮放
        return chartView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(initialFundTitle)
        view.addSubview(initialFund)
        view.addSubview(newInvestmentTitle)
        view.addSubview(newInvestment)
        view.addSubview(annualizedRateTitle)
        view.addSubview(annualizedRate)
        view.addSubview(investmentYearTitle)
        view.addSubview(investmentYearStepText)
        view.addSubview(investmentYearStep)
        view.addSubview(calculateButton)
        view.addSubview(lineChartView)
        
        configureUI()
        stepValue()
        setChartData()
        
        calculateButton.addTarget(self, action: #selector(calculateValue), for: .touchUpInside)
    }
    
    // MARK: - Functions
    private func stepValue() {
        investmentYearStep.addTarget(self, action: #selector(addValueStep(_:)), for: .valueChanged)
    }
    
    private func setChartData() {
        // 測試數據
        viewModel.$totalCalculateData.receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                let dataEntries: [ChartDataEntry] = data.map{ ChartDataEntry(x: Double($0.totelYear), y: round($0.totelData)) }
                
                // 設置數據集
                let dataSet = LineChartDataSet(entries: dataEntries, label: "每年複利數據")
                dataSet.colors = [.systemOrange] // 線條顏色
                dataSet.circleColors = [.systemBlue] // 圓點顏色
                dataSet.circleRadius = 3 // 圓點大小
                dataSet.lineWidth = 2 // 線條寬度
                dataSet.valueColors = [.white] // 資料標籤顏色
                dataSet.drawValuesEnabled = true // 是否顯示資料標籤
                
                // 設置 LineChartData 並賦值給圖表
                let lineChartData = LineChartData(dataSet: dataSet)
                self?.lineChartView.data = lineChartData
                
                self?.lineChartView.animate(xAxisDuration: 2.5, yAxisDuration: 2.5, easingOption: .linear)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Selectors
    @objc func addValueStep(_ sender: UIStepper) {
        investmentYearStepText.text = "\(Int(sender.value))"
    }
    
    //計算數值
    @objc func calculateValue() {
        viewModel.calculateTotalValue(initialFundValue: initialFund.text ?? "0.0", newInvestmentValue: newInvestment.text ?? "0.0", annualizedRateValue: annualizedRate.text ?? "0.0", investmentYearStepValue: investmentYearStepText.text ?? "1")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            initialFundTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            initialFundTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            initialFundTitle.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            initialFundTitle.heightAnchor.constraint(equalToConstant: 50),
            
            initialFund.topAnchor.constraint(equalTo: initialFundTitle.bottomAnchor),
            initialFund.leadingAnchor.constraint(equalTo: initialFundTitle.leadingAnchor),
            initialFund.trailingAnchor.constraint(equalTo: initialFundTitle.trailingAnchor),
            initialFund.heightAnchor.constraint(equalToConstant: 50),
            
            newInvestmentTitle.topAnchor.constraint(equalTo: initialFund.bottomAnchor),
            newInvestmentTitle.leadingAnchor.constraint(equalTo: initialFundTitle.leadingAnchor),
            newInvestmentTitle.trailingAnchor.constraint(equalTo: initialFundTitle.trailingAnchor),
            newInvestmentTitle.heightAnchor.constraint(equalToConstant: 50),
            
            newInvestment.topAnchor.constraint(equalTo: newInvestmentTitle.bottomAnchor),
            newInvestment.leadingAnchor.constraint(equalTo: newInvestmentTitle.leadingAnchor),
            newInvestment.trailingAnchor.constraint(equalTo: newInvestmentTitle.trailingAnchor),
            newInvestment.heightAnchor.constraint(equalToConstant: 50),
            
            annualizedRateTitle.topAnchor.constraint(equalTo: newInvestment.bottomAnchor),
            annualizedRateTitle.leadingAnchor.constraint(equalTo: initialFundTitle.leadingAnchor),
            annualizedRateTitle.trailingAnchor.constraint(equalTo: initialFundTitle.trailingAnchor),
            annualizedRateTitle.heightAnchor.constraint(equalToConstant: 50),
            
            annualizedRate.topAnchor.constraint(equalTo: annualizedRateTitle.bottomAnchor),
            annualizedRate.leadingAnchor.constraint(equalTo: annualizedRateTitle.leadingAnchor),
            annualizedRate.trailingAnchor.constraint(equalTo: annualizedRateTitle.trailingAnchor),
            annualizedRate.heightAnchor.constraint(equalToConstant: 50),
            
            investmentYearTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            investmentYearTitle.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
            investmentYearTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            investmentYearTitle.heightAnchor.constraint(equalToConstant: 50),
            
            investmentYearStepText.topAnchor.constraint(equalTo: investmentYearTitle.bottomAnchor),
            investmentYearStepText.leadingAnchor.constraint(equalTo: investmentYearTitle.leadingAnchor),
            investmentYearStepText.widthAnchor.constraint(equalToConstant: 50),
            investmentYearStepText.heightAnchor.constraint(equalToConstant: 40),
            
            investmentYearStep.topAnchor.constraint(equalTo: investmentYearStepText.bottomAnchor, constant: 5),
            investmentYearStep.leadingAnchor.constraint(equalTo: investmentYearTitle.leadingAnchor),
            investmentYearStep.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            investmentYearStep.heightAnchor.constraint(equalToConstant: 50),
            
            calculateButton.topAnchor.constraint(equalTo: investmentYearStep.bottomAnchor, constant: 10),
            calculateButton.leadingAnchor.constraint(equalTo: investmentYearTitle.leadingAnchor),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calculateButton.bottomAnchor.constraint(equalTo: annualizedRate.bottomAnchor),
            
            lineChartView.topAnchor.constraint(equalTo: annualizedRate.bottomAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Extension

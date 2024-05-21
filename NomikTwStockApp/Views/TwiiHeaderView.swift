//
//  TwiiHeaderView.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/20.
//

import UIKit
import DGCharts

class TwiiHeaderView: UIView {
    
    private enum SectionTabs: String {
        case movers = "台股漲跌排行"
        case volume = "成交量排行"
        case value = "成交值排行"
        
        var index: Int {
            switch self {
            case .movers:
                return 0
            case .volume:
                return 1
            case .value:
                return 2
            }
        }
    }
    
    private var sectionTab: Int = 0 {
        didSet {
            UIView.animate(withDuration: 0.3, delay: , options: .curveEaseInOut) {
                <#code#>
            }
        }
    }
    
    
    private let tabButtons: [UIButton] = ["台股漲跌排行", "成交量排行", "成交值排行"].map{ titles in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(titles, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        return button
    }
    
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    
    
    
    private var lineChart: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 5)
                
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        leftAxis.setLabelCount(10, force: false)
        leftAxis.labelPosition = .outsideChart
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottomInside
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        xAxis.axisMaximum = 13.5
        xAxis.axisMinimum = 9
        xAxis.granularity = 1
        
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineChart)
        addSubview(sectionStack)
        lineChart.delegate = self
        
        setData()
        configureUI()
        configureStackButton()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineChart.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 1.2)
    }
    
    private func setData() {
        
        var entrieData: [ChartDataEntry] = []
        
        APIService.shared.twiiCall { result in
            switch result {
            case .success(let twiiDataCall):
                let centerValue: Double = twiiDataCall.data[0].open
                let yAxisRange: Double = 327
                
                let limitLine = ChartLimitLine(limit: centerValue, label: "開盤價")
                limitLine.lineWidth = 1
                limitLine.lineColor = .systemYellow
                
                for twiiDatas in twiiDataCall.data {
                    let dateString = twiiDatas.date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

                    if let date = dateFormatter.date(from: dateString) {
                        dateFormatter.dateFormat = "HH:mm"
                        let time = dateFormatter.string(from: date)
                        let reString = time.replacingOccurrences(of: ":", with: ".")
                        
                        if reString == "09.00" {
                            entrieData.append(ChartDataEntry(x: 9.00, y: Double(twiiDatas.open)))
                        } else {
                            entrieData.append(ChartDataEntry(x: Double(reString) ?? 0.0, y: Double(twiiDatas.close)))
                        }
                    } else {
                        print("日期字符串格式錯誤")
                    }
                }
                
                DispatchQueue.main.async {
                    let set1 = LineChartDataSet(entries: entrieData, label: "大盤漲跌")
                    set1.mode = .cubicBezier
                    set1.drawCirclesEnabled = false
                    
                    if twiiDataCall.data.last!.close > twiiDataCall.data[0].open {
                        set1.setColor(.red)
                        set1.lineWidth = 1
                        set1.fill = ColorFill(color: .red)
                        set1.fillAlpha = 0.2
                        set1.drawFilledEnabled = true
                    } else if twiiDataCall.data.last!.close < twiiDataCall.data[0].open {
                        set1.setColor(.green)
                        set1.lineWidth = 1
                        set1.fill = ColorFill(color: .green)
                        set1.fillAlpha = 0.2
                        set1.drawFilledEnabled = true
                    } else {
                        set1.drawFilledEnabled = false
                    }
                    
                    self.lineChart.leftAxis.axisMinimum = centerValue - yAxisRange / 2
                    self.lineChart.leftAxis.axisMaximum = centerValue + yAxisRange / 2
                    self.lineChart.leftAxis.addLimitLine(limitLine)
            
            
                    let data = LineChartData(dataSet: set1)
                    data.setDrawValues(false)
                    self.lineChart.data = data
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureStackButton() {
        for (i, button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.movers.rawValue:
            sectionTab = 0
        case SectionTabs.volume.rawValue:
            sectionTab = 1
        case SectionTabs.value.rawValue:
            sectionTab = 2
        default:
            sectionTab = 0
        }
    }
    
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sectionStack.topAnchor.constraint(equalTo: lineChart.bottomAnchor),
            sectionStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
   
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TwiiHeaderView: ChartViewDelegate {
    
}


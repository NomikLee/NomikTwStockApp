//
//  TwiiHeaderView.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/20.
//

import UIKit
import DGCharts

// 定義協議 TwiiHeaderViewDelegate 來處理標籤點擊事件
protocol TwiiHeaderViewDelegate: AnyObject {
    func twiiHeaderViewDidTapMoversUP()
    func twiiHeaderViewDidTapMoversDown()
    func twiiHeaderViewDidTapVolume()
}

// 定義 TwiiHeaderView 類，繼承自 UIView
class TwiiHeaderView: UIView {
    
    // 定義 SectionCandlTabs 枚舉來表示不同的標籤
    private enum SectionTabs: String {
        case moversUP = "台股上漲排行"
        case moversDown = "台股下跌排行"
        case volume = "成交量排行"
    }
    
    // 定義代理屬性，使用 weak 關鍵字避免循環引用
    weak var delegate: TwiiHeaderViewDelegate?
    
    // 定義計時器屬性
    var timer: Timer?
    
    // 定義佈局約束陣列
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    // 定義視圖條，用於顯示當前選中的標籤
    private let viewBar: UIView = {
        let viewBar = UIView()
        viewBar.translatesAutoresizingMaskIntoConstraints = false
        viewBar.backgroundColor = .systemOrange
        return viewBar
    }()
    
    // 定義當前選中的標籤索引，當值改變時觸發相關視圖更新
    private var sectionTab: Int = 0 {
        didSet {
            for i in 0..<tabButtons.count {
                UIView.animate(withDuration: 0.3, delay: 0 , options: .curveEaseInOut) { [weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = (self?.sectionTab == i ? .label : .secondaryLabel)
                    self?.leadingAnchors[i].isActive = (self?.sectionTab == i ? true : false)
                    self?.trailingAnchors[i].isActive = (self?.sectionTab == i ? true : false)
                    self?.layoutIfNeeded()
                }
            }
            
            // 根據選中的標籤索引觸發相應的代理方法
            switch sectionTab {
            case 0:
                delegate?.twiiHeaderViewDidTapMoversUP()
            case 1:
                delegate?.twiiHeaderViewDidTapMoversDown()
            default:
                delegate?.twiiHeaderViewDidTapVolume()
            }
        }
    }
    
    // 創建標籤按鈕陣列
    private let tabButtons: [UIButton] = ["台股上漲排行", "台股下跌排行", "成交量排行"].map{ titles in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(titles, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        return button
    }
    
    // 創建 UIStackView 來容納標籤按鈕
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    // 創建 LineChartView 來顯示圖表
    private var lineChart: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 2.5)
                
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        leftAxis.setLabelCount(10, force: false)
        leftAxis.labelPosition = .outsideChart
        leftAxis.drawGridLinesEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottomInside
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 270
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.enabled = false
        
        return chartView
    }()
    
    // 將雙精度值轉換為字符串
    private func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(format: "%.0f", value)
    }
    
    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineChart)
        addSubview(sectionStack)
        addSubview(viewBar)
        
        lineChart.delegate = self
        
        setData()
        startTimer()
        configureUI()
        configureStackButton()
    }
    
    // 當視圖佈局改變時調整圖表的大小
    override func layoutSubviews() {
        super.layoutSubviews()
        lineChart.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 1.2)
    }
    
    // 啟動計時器，每5秒更新一次數據
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.setData()
        })
    }
    
    // 設置圖表數據
    private func setData() {
        var entrieData: [ChartDataEntry] = []
        
        APIService.shared.twiiCall { result in
            switch result {
            case .success(let twiiDataCall):
                let centerValue: Double = twiiDataCall.data.first?.open ?? 0.0
                let yAxisRange: Double = 1000
                
                let limitLine = ChartLimitLine(limit: centerValue, label: "開盤價\(centerValue)")
                limitLine.lineWidth = 1
                limitLine.lineColor = .systemYellow
                
                var temp = 0.0
                for twiiDatas in twiiDataCall.data {
                    let dateString = twiiDatas.date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

                    if let date = dateFormatter.date(from: dateString) {
                        dateFormatter.dateFormat = "HH:mm"
                        let time = dateFormatter.string(from: date)
                        let reString = time.replacingOccurrences(of: ":", with: ".")
                        
                        if reString == "09.00" {
                            entrieData.append(ChartDataEntry(x: temp, y: Double(twiiDatas.open)))
                        } else {
                            temp += 1
                            entrieData.append(ChartDataEntry(x: temp, y: Double(twiiDatas.close)))
                        }
                    } else {
                        print("日期字符串格式錯誤")
                    }
                }
                
                DispatchQueue.main.async {
                    let set1 = LineChartDataSet(entries: entrieData, label: "大盤加權指數")
                    set1.mode = .cubicBezier
                    set1.drawCirclesEnabled = false
                    
                    if twiiDataCall.data.last?.close ?? 0.0 > twiiDataCall.data.first?.open ?? 0.0 {
                        set1.setColor(.red)
                        set1.lineWidth = 1
                        set1.fill = ColorFill(color: .red)
                        set1.fillAlpha = 0.2
                        set1.drawFilledEnabled = true
                    } else if twiiDataCall.data.last?.close ?? 0.0 < twiiDataCall.data.first?.open ?? 0.0 {
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
    
    // 配置標籤按鈕
    private func configureStackButton() {
        for (i, button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            
            if i == sectionTab {
                button.tintColor = .label
            } else {
                button.tintColor = .secondaryLabel
            }
            
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    
    // 標籤按鈕的點擊事件
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.moversUP.rawValue:
            sectionTab = 0
        case SectionTabs.moversDown.rawValue:
            sectionTab = 1
        case SectionTabs.volume.rawValue:
            sectionTab = 2
        default:
            sectionTab = 0
        }
    }
    
    // 配置用戶界面
    private func configureUI() {
        for i in 0..<tabButtons.count {
            let leadingAnchor = viewBar.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            let trailingAnchor = viewBar.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            leadingAnchors.append(leadingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        NSLayoutConstraint.activate([
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sectionStack.topAnchor.constraint(equalTo: lineChart.bottomAnchor),
            sectionStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leadingAnchors[0],
            trailingAnchors[0],
            viewBar.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor),
            viewBar.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
   
    // 初始化方法（未實作）
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 擴展 TwiiHeaderView 以實現 ChartViewDelegate 協議
extension TwiiHeaderView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}

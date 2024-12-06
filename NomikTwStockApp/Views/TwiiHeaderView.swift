//
//  TwiiHeaderView.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/20.
//

import UIKit
import DGCharts

// 定義Delegate處理標籤點擊
protocol TwiiHeaderViewDelegate: AnyObject {
    func twiiHeaderViewDidTapMoversUP()
    func twiiHeaderViewDidTapMoversDown()
    func twiiHeaderViewDidTapVolume()
}

private enum SectionTabs: String {
    case moversUP = "台股上漲排行"
    case moversDown = "台股下跌排行"
    case volume = "成交量排行"
}

class TwiiHeaderView: UIView {
    
    weak var delegate: TwiiHeaderViewDelegate?
    
    // MARK: - Variables
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
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
    
    // MARK: - UI Components
    private let viewBar: UIView = {
        let viewBar = UIView()
        viewBar.translatesAutoresizingMaskIntoConstraints = false
        viewBar.backgroundColor = .systemOrange
        return viewBar
    }()
    
    private let tabButtons: [UIButton] = ["台股上漲排行", "台股下跌排行", "成交量排行"].map{ titles in
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
        chartView.animate(xAxisDuration: 2.5)
        chartView.doubleTapToZoomEnabled = false
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = true
        chartView.rightAxis.drawGridLinesEnabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisRange = 271
        chartView.xAxis.granularity = 1
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.enabled = false
        
        return chartView
    }()
    
    private let twiiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .systemOrange
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineChart)
        lineChart.addSubview(twiiLabel)
        addSubview(sectionStack)
        addSubview(viewBar)
        
        setData()
        startTimer()
        configureUI()
        configureStackButton()
        
        lineChart.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineChart.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 1.2)
    }
    
    // MARK: - Functions
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.setData()
        })
    }
    
    // 設置圖表數據
    private func setData() {
        var entrieData: [ChartDataEntry] = []
        
        APIServiceManager.shared.twiiCall { result in
            switch result {
            case .success(let twiiDataCall):
                let centerValue: Double = twiiDataCall.data.first?.open ?? 0.0
                
                let limitLine = ChartLimitLine(limit: centerValue, label: "開盤價\(centerValue)")
                limitLine.lineWidth = 1
                limitLine.lineColor = .systemYellow
                
                for i in 0..<twiiDataCall.data.count {
                    if i == 0 {
                        entrieData.append(ChartDataEntry(x: Double(i), y: Double(twiiDataCall.data[i].open)))
                    } else {
                        entrieData.append(ChartDataEntry(x: Double(i), y: Double(twiiDataCall.data[i].close)))
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
                    
                    self.lineChart.rightAxis.addLimitLine(limitLine)
            
                    let data = LineChartData(dataSet: set1)
                    data.setDrawValues(false)
                    self.lineChart.data = data
                    self.lineChart.notifyDataSetChanged()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

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
    
    // MARK: - Selectors
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
    
    // MARK: - UI Setup
    private func configureUI() {
        for i in 0..<tabButtons.count {
            let leadingAnchor = viewBar.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            let trailingAnchor = viewBar.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            leadingAnchors.append(leadingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        NSLayoutConstraint.activate([
            twiiLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            twiiLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            twiiLabel.heightAnchor.constraint(equalToConstant: 25),
            twiiLabel.topAnchor.constraint(equalTo: topAnchor),
            
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
}

// MARK: - Extension
extension TwiiHeaderView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let twiiValue = entry.y
        twiiLabel.text = "Price \(twiiValue)"
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        twiiLabel.text = ""
    }
}

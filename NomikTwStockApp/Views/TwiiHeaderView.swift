//
//  TwiiHeaderView.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/20.
//

import UIKit
import DGCharts

class TwiiHeaderView: UIView {
    
    private var lineChart: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 5)
                
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        leftAxis.setLabelCount(100, force: false)
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
        
        lineChart.delegate = self
        setData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineChart.frame = bounds
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TwiiHeaderView: ChartViewDelegate {
    
}


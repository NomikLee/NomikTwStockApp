//
//  DetailViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/24.
//

import UIKit
import DGCharts
import FirebaseFirestore


class DetailViewController: UIViewController {
    
    private var padding: CGFloat = 10.0
    
    private let dataBase = Firestore.firestore()
    private lazy var doc = dataBase.document("Favorite/TwStock")
    
    private enum SectionTabs: String {
        case candle5K = "5K"
        case candle15K = "15K"
        case candle60K = "60K"
        case candle日K = "日K"
        case candle週K = "週K"
        case candle月K = "月K"
    }
    
    private let detailUIview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBackground.cgColor
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private let detailName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let detailPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.text = "2770.5"
        label.textAlignment = .center
        return label
    }()
    
    private let detailChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "200.0 (9.99%)"
        label.textColor = .green
        label.textAlignment = .center
        return label
    }()
    
    private let detailDataUIview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let detailOHLA: [UILabel] = ["最高價", "開盤價", "最低價", "均價"].map{ titles in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = titles
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }
    
    private lazy var detailNameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: detailOHLA)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let detailOHLAPrice: [UILabel] = ["2000.5", "1450.5", "1110.0", "1270.5"].map{ titles in
        let label = UILabel()
        label.text = titles
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }
    
    private let bidValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .green
        label.text = "內盤 25242 (43%)"
        return label
    }()
    
    private let askValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .red
        label.text = "外盤 53456 (67%)"
        return label
    }()
    
    private let detailBidAskLine: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemGreen
        progressView.trackTintColor = .systemRed
        progressView.progress = 0.43
        return progressView
    }()
    
    private lazy var detailPriceStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: detailOHLAPrice)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let detailHorizontalLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private let detailStraightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        return view
    }()
    
    private let detailPePbDy: [UILabel] = ["殖利率: 2.71", "本益比: 615.00", "淨值比: 0.58"].map{ titles in
        let label = UILabel()
        label.text = titles
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }
    
    private lazy var detailPePbDyStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: detailPePbDy)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let detailValueVolumeAmp: [UILabel] = ["成交值(萬): 310198", "成交量(張): 54538", "當日振幅: 1.77"].map{ titles in
        let label = UILabel()
        label.text = titles
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }
    
    private lazy var detailValueVolumeAmpStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: detailValueVolumeAmp)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    
    
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
    
    private let titleButtons: [UIButton] = ["5K", "15K", "60K", "日K", "週K", "月K"].map{ titles in
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(titles, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.tintColor = .label
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        return button
    }
    
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: titleButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private var sectionTab: Int = 0 {
        didSet {
            for i in 0..<titleButtons.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    self.sectionStack.arrangedSubviews[i].tintColor = (self.sectionTab == i ? .label : .secondaryLabel)
                    self.sectionStack.arrangedSubviews[i].backgroundColor = (self.sectionTab == i ? .systemPurple : .systemBackground)
                    self.sectionStack.arrangedSubviews[i].layer.borderColor = (self.sectionTab == i ? UIColor.systemPurple.cgColor : UIColor.systemBackground.cgColor)
                    self.sectionStack.arrangedSubviews[i].layer.masksToBounds = (self.sectionTab == i ? true : false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addFavoriteTap))
        view.addSubview(detailUIview)
        detailUIview.addSubview(detailName)
        detailUIview.addSubview(detailPrice)
        detailUIview.addSubview(detailChange)
        view.addSubview(candleStickChartView)
        view.addSubview(sectionStack)
        view.addSubview(detailDataUIview)
        detailDataUIview.addSubview(detailHorizontalLine)
        detailDataUIview.addSubview(detailStraightLine)
        detailDataUIview.addSubview(detailNameStack)
        detailDataUIview.addSubview(detailPriceStack)
        detailDataUIview.addSubview(detailPePbDyStack)
        detailDataUIview.addSubview(detailValueVolumeAmpStack)
        detailDataUIview.addSubview(detailBidAskLine)
        detailDataUIview.addSubview(bidValue)
        detailDataUIview.addSubview(askValue)
        
        detailName.text = "台積電"
        
        setCandleData()
        configureUI()
        configureStackButton()
        
    }
    
    @objc private func addFavoriteTap(){
        doc.setData(["2887" : "台新金", "2330": "台積電"])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(subFavoriteTap))
    }
    
    @objc private func subFavoriteTap() {
        doc.updateData(["2887" : FieldValue.delete()])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addFavoriteTap))
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
    
    private func configureStackButton(){
        for (i, button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            
            if i == sectionTab {
                button.backgroundColor = .systemPurple
                button.tintColor = .label
                button.layer.borderColor = UIColor.systemPurple.cgColor
                button.layer.masksToBounds = true
            }else {
                button.backgroundColor = .systemBackground
                button.tintColor = .secondaryLabel
            }
            
            button.addTarget(self, action: #selector(didTabTap), for: .touchUpInside)
        }
    }
    
    @objc private func didTabTap(_ buttonTab: UIButton) {
        guard let label = buttonTab.titleLabel?.text else { return }
        
        switch label {
        case SectionTabs.candle5K.rawValue:
            sectionTab = 0
        case SectionTabs.candle15K.rawValue:
            sectionTab = 1
        case SectionTabs.candle60K.rawValue:
            sectionTab = 2
        case SectionTabs.candle日K.rawValue:
            sectionTab = 3
        case SectionTabs.candle週K.rawValue:
            sectionTab = 4
        case SectionTabs.candle月K.rawValue:
            sectionTab = 5
        default:
            sectionTab = 0
        }
    }
    
    private func configureUI() {
        
        for titleButton in titleButtons {
            NSLayoutConstraint.activate([
                titleButton.widthAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        for dOHLA in detailOHLA {
            NSLayoutConstraint.activate([
                dOHLA.widthAnchor.constraint(equalToConstant: 80)
            ])
        }
        
        for dOHLAPrice in detailOHLAPrice {
            NSLayoutConstraint.activate([
                dOHLAPrice.widthAnchor.constraint(equalToConstant: 80)
            ])
        }
        
        NSLayoutConstraint.activate([
            
            detailUIview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            detailUIview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            detailUIview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            detailUIview.heightAnchor.constraint(equalToConstant: 90),
            
            detailName.centerYAnchor.constraint(equalTo: detailUIview.centerYAnchor),
            detailName.leadingAnchor.constraint(equalTo: detailUIview.leadingAnchor, constant: 20),
            
            detailPrice.centerYAnchor.constraint(equalTo: detailUIview.centerYAnchor, constant: -15),
            detailPrice.trailingAnchor.constraint(equalTo: detailUIview.trailingAnchor, constant: -15),
            
            detailChange.centerYAnchor.constraint(equalTo: detailUIview.centerYAnchor, constant: 15),
            detailChange.trailingAnchor.constraint(equalTo: detailPrice.trailingAnchor),
            
            candleStickChartView.topAnchor.constraint(equalTo: detailUIview.bottomAnchor, constant: padding),
            candleStickChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            candleStickChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            candleStickChartView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            sectionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            sectionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            sectionStack.topAnchor.constraint(equalTo: candleStickChartView.bottomAnchor, constant: 20),
            
            detailDataUIview.topAnchor.constraint(equalTo: sectionStack.bottomAnchor, constant: padding),
            detailDataUIview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            detailDataUIview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            detailDataUIview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            
            detailNameStack.topAnchor.constraint(equalTo: detailDataUIview.topAnchor, constant: padding),
            detailNameStack.leadingAnchor.constraint(equalTo: detailDataUIview.leadingAnchor, constant: 20),
            detailNameStack.trailingAnchor.constraint(equalTo: detailDataUIview.trailingAnchor, constant: -20),
            detailNameStack.heightAnchor.constraint(equalToConstant: 20),
            
            detailPriceStack.topAnchor.constraint(equalTo: detailNameStack.bottomAnchor, constant: 5),
            detailPriceStack.leadingAnchor.constraint(equalTo: detailDataUIview.leadingAnchor, constant: 20),
            detailPriceStack.trailingAnchor.constraint(equalTo: detailDataUIview.trailingAnchor, constant: -20),
            detailPriceStack.heightAnchor.constraint(equalToConstant: 30),
            
            detailBidAskLine.leadingAnchor.constraint(equalTo: detailDataUIview.leadingAnchor, constant: padding),
            detailBidAskLine.trailingAnchor.constraint(equalTo: detailDataUIview.trailingAnchor, constant: -padding),
            detailBidAskLine.bottomAnchor.constraint(equalTo: detailHorizontalLine.bottomAnchor, constant: -20),
            detailBidAskLine.heightAnchor.constraint(equalToConstant: 20),
            
            bidValue.leadingAnchor.constraint(equalTo: detailBidAskLine.leadingAnchor),
            bidValue.bottomAnchor.constraint(equalTo: detailBidAskLine.topAnchor, constant: -10),
            bidValue.heightAnchor.constraint(equalToConstant: 15),
            
            askValue.trailingAnchor.constraint(equalTo: detailBidAskLine.trailingAnchor),
            askValue.bottomAnchor.constraint(equalTo: detailBidAskLine.topAnchor, constant: -10),
            askValue.heightAnchor.constraint(equalToConstant: 15),
            
            detailHorizontalLine.topAnchor.constraint(equalTo: detailDataUIview.centerYAnchor),
            detailHorizontalLine.leadingAnchor.constraint(equalTo: detailDataUIview.leadingAnchor),
            detailHorizontalLine.trailingAnchor.constraint(equalTo: detailDataUIview.trailingAnchor),
            detailHorizontalLine.heightAnchor.constraint(equalToConstant: 2),
            
            detailPePbDyStack.topAnchor.constraint(equalTo: detailHorizontalLine.bottomAnchor, constant: padding),
            detailPePbDyStack.leadingAnchor.constraint(equalTo: detailDataUIview.leadingAnchor, constant: 20),
            detailPePbDyStack.bottomAnchor.constraint(equalTo: detailDataUIview.bottomAnchor, constant: -20),
            
            detailStraightLine.topAnchor.constraint(equalTo: detailHorizontalLine.bottomAnchor),
            detailStraightLine.bottomAnchor.constraint(equalTo: detailDataUIview.bottomAnchor),
            detailStraightLine.leadingAnchor.constraint(equalTo: detailPePbDyStack.trailingAnchor, constant: padding),
            detailStraightLine.widthAnchor.constraint(equalToConstant: 2),
            
            detailValueVolumeAmpStack.topAnchor.constraint(equalTo: detailHorizontalLine.bottomAnchor, constant: padding),
            detailValueVolumeAmpStack.leadingAnchor.constraint(equalTo: detailStraightLine.leadingAnchor, constant: padding),
            detailValueVolumeAmpStack.bottomAnchor.constraint(equalTo: detailDataUIview.bottomAnchor, constant: -20),
            
        ])
    }
}

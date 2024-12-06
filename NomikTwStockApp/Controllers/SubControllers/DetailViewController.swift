//
//  DetailViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/24.
//

import UIKit
import DGCharts
import FirebaseFirestore
import Combine

private enum SectionTabs: String {
    case candle5K = "5K"
    case candle15K = "15K"
    case candle60K = "60K"
    case candle日K = "日K"
    case candle週K = "週K"
    case candle月K = "月K"
}

class DetailViewController: UIViewController {
    
    private var viewModel = StockDataViewModels()
    
    // MARK: - Variables
    private var padding: CGFloat = 10.0
    private var checkFavoriteCode: [String] = []
    private var candleValue: [CandleRespose] = []
    private let dataBase = Firestore.firestore()
    private lazy var doc = dataBase.document("Favorite/TwStocks")
    
    private var sectionTab: Int = 3 {
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
    
    // MARK: - UI Components
    private let detailUIview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBackground.cgColor
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let detailUiMiniView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
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
        label.text = "---"
        label.textAlignment = .center
        return label
    }()
    
    private let detailChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "--- (---%)"
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
    
    private let detailOHLAPrice: [UILabel] = ["---", "---", "---", "---"].map{ titles in
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
        label.text = "內盤 --- (--%)"
        return label
    }()
    
    private let askValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .red
        label.text = "外盤 --- (--%)"
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
    
    private let detailPePbDy: [UILabel] = ["殖利率: ---", "本益比: ---", "淨值比: ---"].map{ titles in
        let label = UILabel()
        label.text = titles
        label.textAlignment = .left
        label.textColor = .secondaryLabel
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
    
    private let detailValueVolumeAmp: [UILabel] = ["成交值(萬): ---", "成交量(張): ---", "當日振幅: ---"].map{ titles in
        let label = UILabel()
        label.text = titles
        label.textAlignment = .left
        label.textColor = .secondaryLabel
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
    
    private let favoritePushButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        return button
    }()
    
    private let candleStickChartView: CandleStickChartView = {
        let candleView = CandleStickChartView()
        candleView.translatesAutoresizingMaskIntoConstraints = false
        candleView.chartDescription.enabled = false
        candleView.doubleTapToZoomEnabled = false
        candleView.legend.enabled = false
        
        candleView.xAxis.labelPosition = .bottom
        candleView.xAxis.enabled = false
        candleView.xAxis.drawGridLinesEnabled = false
        candleView.xAxis.granularity = 1.0

        candleView.rightAxis.drawGridLinesEnabled = false
        candleView.leftAxis.enabled = false
        return candleView
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
    
    private let candlePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemOrange
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        view.addSubview(detailUIview)
        detailUIview.addSubview(detailName)
        detailUIview.addSubview(detailUiMiniView)
        detailUiMiniView.addSubview(detailPrice)
        detailUiMiniView.addSubview(detailChange)
        
        view.addSubview(candleStickChartView)
        view.addSubview(sectionStack)
        view.addSubview(detailDataUIview)
        candleStickChartView.addSubview(candlePriceLabel)
        detailDataUIview.addSubview(detailHorizontalLine)
        detailDataUIview.addSubview(detailStraightLine)
        detailDataUIview.addSubview(detailNameStack)
        detailDataUIview.addSubview(detailPriceStack)
        detailDataUIview.addSubview(detailPePbDyStack)
        detailDataUIview.addSubview(detailValueVolumeAmpStack)
        detailDataUIview.addSubview(detailBidAskLine)
        detailDataUIview.addSubview(bidValue)
        detailDataUIview.addSubview(askValue)
        detailDataUIview.addSubview(favoritePushButton)
        
        configureUI()
        configureStarUI()
        configureStackButton()
        setCandleData(to: "D")
        configureDetailData()
        
        candleStickChartView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.configureDetailData()
        }
    }
    
    // MARK: - Functions
    private func checkFavorite(completion: @escaping([String]) -> Void) {
        doc.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else { return }
            
            DispatchQueue.main.async {
                let keysCollection: Dictionary<String, Any>.Keys = data.keys
                self.checkFavoriteCode = Array(keysCollection)
                completion(self.checkFavoriteCode)
            }
        }
    }
    
    func configureDetailData() {
        viewModel.GetQuoteSingle(symbolCode: self.title ?? "無資料") { [weak self] result in
            switch result {
            case .success(let quoteSingle):
                let bidPercent = quoteSingle.total.tradeVolumeAtBid / (quoteSingle.total.tradeVolumeAtBid + quoteSingle.total.tradeVolumeAtAsk)
                let bidPercentFormat = String(format: "%.0f", (bidPercent * 100))
                let bidPercentFormatLine = String(format: "%.2f", bidPercent)
                let askPercent = quoteSingle.total.tradeVolumeAtAsk / (quoteSingle.total.tradeVolumeAtBid + quoteSingle.total.tradeVolumeAtAsk)
                let askPercentFormat = String(format: "%.0f", (askPercent * 100))
                let singleTradeValue = quoteSingle.total.tradeValue / 10000
                let singleTradeValueFormat = String(format: "%.1f", singleTradeValue)
                
                DispatchQueue.main.async {
                    self?.detailName.text = quoteSingle.name
                    self?.detailPrice.text = "\(quoteSingle.closePrice)"
                    self?.detailChange.text = "\(quoteSingle.change) (\(quoteSingle.changePercent)%)"
                    self?.detailOHLAPrice[0].text = "\(quoteSingle.highPrice)"
                    self?.detailOHLAPrice[1].text = "\(quoteSingle.openPrice)"
                    self?.detailOHLAPrice[2].text = "\(quoteSingle.lowPrice)"
                    self?.detailOHLAPrice[3].text = "\(quoteSingle.avgPrice)"
                    self?.detailValueVolumeAmp[0].text = "成交值(萬): \(singleTradeValueFormat)"
                    self?.detailValueVolumeAmp[1].text = "成交量(張): \(quoteSingle.total.tradeVolume)"
                    self?.detailValueVolumeAmp[2].text = "當日振幅: \(quoteSingle.amplitude)"
                    self?.bidValue.text = "內盤 \(quoteSingle.total.tradeVolumeAtBid) (\(bidPercentFormat)%)"
                    self?.askValue.text = "外盤 \(quoteSingle.total.tradeVolumeAtAsk) (\(askPercentFormat)%)"
                    self?.detailBidAskLine.progress = Float(bidPercentFormatLine) ?? 0.0
                    
                    if quoteSingle.change > 0 {
                        self?.detailChange.textColor = .systemRed
                    }else if quoteSingle.change < 0 {
                        self?.detailChange.textColor = .systemGreen
                    }else {
                        self?.detailChange.textColor = .white
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        viewModel.GetPeDyPbCall { [weak self] result in
            switch result {
            case .success(let peDyPbData):
                DispatchQueue.main.async {
                    let singlePeDyPbData = peDyPbData.first {$0.Code == self?.title}
                    self?.detailPePbDy[0].text = "殖利率: \(singlePeDyPbData?.DividendYield ?? "---")"
                    self?.detailPePbDy[1].text = "本益比: \(singlePeDyPbData?.PEratio ?? "---")"
                    self?.detailPePbDy[2].text = "淨值比: \(singlePeDyPbData?.PBratio ?? "---")"
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setCandleData(to dataTime: String) {
        
        var yCandleValues: [CandleChartDataEntry] = []
        candleValue = []
        
        viewModel.GetCandle(symbolCode: self.title ?? "無資料", timeframe: dataTime) { [weak self] result in
            switch result {
            case .success(let candles):
                let temp = candles.data.count - 1
                
                self?.candleValue.append(candles)
                
                for i in (0..<candles.data.count).reversed(){
                    yCandleValues.append(CandleChartDataEntry(x: Double(temp - i), shadowH: candles.data[i].high, shadowL: candles.data[i].low, open: candles.data[i].open, close: candles.data[i].close))
                }
                
                let setCandle = CandleChartDataSet(entries: yCandleValues, label: "")
                setCandle.axisDependency = .right
                setCandle.setColor(UIColor.systemBackground)
                setCandle.shadowColor = .darkGray
                setCandle.shadowWidth = 0.8
                setCandle.decreasingColor = .red
                setCandle.decreasingFilled = true
                setCandle.increasingColor = .green
                setCandle.increasingFilled = true
                setCandle.neutralColor = .white
                setCandle.drawValuesEnabled = false
                
                DispatchQueue.main.async {
                    self?.candleStickChartView.data = CandleChartData(dataSet: setCandle)
                    self?.candleStickChartView.xAxis.axisMaximum = Double(yCandleValues.count) + 1.0
                    self?.candleStickChartView.notifyDataSetChanged()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
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
    
    // MARK: - Selectors
    @objc private func didTabTap(_ buttonTab: UIButton) {
        guard let label = buttonTab.titleLabel?.text else { return }
        
        switch label {
        case SectionTabs.candle5K.rawValue:
            sectionTab = 0
            setCandleData(to: "5")
        case SectionTabs.candle15K.rawValue:
            sectionTab = 1
            setCandleData(to: "15")
        case SectionTabs.candle60K.rawValue:
            sectionTab = 2
            setCandleData(to: "60")
        case SectionTabs.candle日K.rawValue:
            sectionTab = 3
            setCandleData(to: "D")
        case SectionTabs.candle週K.rawValue:
            sectionTab = 4
            setCandleData(to: "W")
        case SectionTabs.candle月K.rawValue:
            sectionTab = 5
            setCandleData(to: "M")
        default:
            sectionTab = 3
        }
    }
    
    @objc private func addFavoriteTap(){
        doc.updateData([self.title : detailName.text ?? ""])
        
        favoritePushButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoritePushButton.addTarget(self, action: #selector(self.subFavoriteTap), for: .touchUpInside)
    }
    
    @objc private func subFavoriteTap() {
        doc.updateData([self.title : FieldValue.delete()])
        
        favoritePushButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoritePushButton.addTarget(self, action: #selector(self.addFavoriteTap), for: .touchUpInside)
    }
    
    // MARK: - UI Setup
    private func configureStarUI() {
        favoritePushButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoritePushButton.addTarget(self, action: #selector(self.addFavoriteTap), for: .touchUpInside)
        
        checkFavorite { result in
            if result.contains(where: {$0 == self.title}) {
                self.favoritePushButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.favoritePushButton.addTarget(self, action: #selector(self.subFavoriteTap), for: .touchUpInside)
            }
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
            
            detailUiMiniView.topAnchor.constraint(equalTo: detailUIview.topAnchor, constant: 2),
            detailUiMiniView.bottomAnchor.constraint(equalTo: detailUIview.bottomAnchor, constant: -2),
            detailUiMiniView.leadingAnchor.constraint(equalTo: detailUIview.centerXAnchor, constant: 40),
            detailUiMiniView.trailingAnchor.constraint(equalTo: detailUIview.trailingAnchor, constant: -2),
            detailUiMiniView.heightAnchor.constraint(equalToConstant: 90),
            
            detailName.centerYAnchor.constraint(equalTo: detailUIview.centerYAnchor),
            detailName.leadingAnchor.constraint(equalTo: detailUIview.leadingAnchor, constant: 20),
            
            detailPrice.centerYAnchor.constraint(equalTo: detailUIview.centerYAnchor, constant: -15),
            detailPrice.trailingAnchor.constraint(equalTo: detailUIview.trailingAnchor, constant: -15),
            
            detailChange.centerYAnchor.constraint(equalTo: detailUIview.centerYAnchor, constant: 15),
            detailChange.trailingAnchor.constraint(equalTo: detailPrice.trailingAnchor),
            
            candleStickChartView.topAnchor.constraint(equalTo: detailUIview.bottomAnchor, constant: padding),
            candleStickChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            candleStickChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            candleStickChartView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            candlePriceLabel.leadingAnchor.constraint(equalTo: candleStickChartView.leadingAnchor),
            candlePriceLabel.bottomAnchor.constraint(equalTo: candleStickChartView.bottomAnchor),
            candlePriceLabel.trailingAnchor.constraint(equalTo: candleStickChartView.trailingAnchor),
            candlePriceLabel.heightAnchor.constraint(equalToConstant: 30),
            
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
            
            favoritePushButton.bottomAnchor.constraint(equalTo: detailDataUIview.bottomAnchor, constant: -20),
            favoritePushButton.trailingAnchor.constraint(equalTo: detailDataUIview.trailingAnchor, constant: -20)
        ])
    }
}
// MARK: - Extension
extension DetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let xSel = entry.x + 1.0 //十字選擇時x軸位置
        let candleValueCount = candleValue[0].data.count //candleValue資料的數量
        
        candlePriceLabel.text = " 高 \(candleValue[0].data[candleValueCount - Int(xSel)].high) 低 \(candleValue[0].data[candleValueCount - Int(xSel)].low) 開 \(candleValue[0].data[candleValueCount - Int(xSel)].open) 關 \(candleValue[0].data[candleValueCount - Int(xSel)].close)"
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        candlePriceLabel.text = ""
    }
}


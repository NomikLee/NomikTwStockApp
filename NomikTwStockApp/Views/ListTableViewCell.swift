//
//  ListTableViewCell.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/20.
//

import UIKit
import Combine

// 自定義 UITableViewCell 類
class ListTableViewCell: UITableViewCell {
    
    // 設置內邊距
    private let padding: CGFloat = 10.0
    
    // 創建一個 StockUpDownViewModels 的實例
    private var viewModel = StockUpDownViewModels()
    // 使用 Set 來存儲 AnyCancellable，以便在取消訂閱時釋放資源
    private var subscriptions: Set<AnyCancellable> = []
    
    // 設置靜態標識符
    static let identifier = "ListTableViewCell"
    
    // 創建 symbolLabel，用於顯示股票代碼
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // 創建 nameLabel，用於顯示股票名稱
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    // 創建 stockStatusLabel，用於顯示股票狀態（上漲、下跌等）
    private let stockStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 3
        label.clipsToBounds = true
        return label
    }()
    
    // 創建 stockPriceLabel，用於顯示股票價格
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // 創建 stockChangePercentLabel，用於顯示股票變化百分比
    private let stockChangePercentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()

    // 初始化方法，設置單元格的子視圖
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(stockStatusLabel)
        contentView.addSubview(stockPriceLabel)
        contentView.addSubview(stockChangePercentLabel)
        
        configureUI()
    }
    
    // 必須實現的初始化方法
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 配置名稱數據的方法
    public func configureNameData(with intoSymbol: String, intoName: String) {
        self.symbolLabel.text = intoSymbol
        self.nameLabel.text = intoName
    }
    
    // 配置股票數據的方法
    public func configureStockData(with intoClosePrice: Double, intoChange: Double, intoChangePercent: Double) {
        self.stockPriceLabel.text = "\(intoClosePrice)"
        self.stockChangePercentLabel.text = "\(intoChange) (\(intoChangePercent)%)"
        bindView(with: intoChangePercent)
    }
    
    // 綁定視圖與 ViewModel
    private func bindView(with changeValue: Double) {
        viewModel.intoChangeValue = changeValue
        self.stockStatusLabel.text = viewModel.stockPriceChange()
        
        // 訂閱 colorChange 屬性變化
        viewModel.$colorChange.sink { [weak self] color in
            self?.stockStatusLabel.backgroundColor = color
        }
        .store(in: &subscriptions)
        
        // 訂閱 intoChangeValue 屬性變化
        viewModel.$intoChangeValue.sink { [weak self] percent in
            guard let percent = percent else { return }
            switch percent {
            case 0.1..<11.0:
                self?.stockStatusLabel.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
                self?.stockChangePercentLabel.textColor = .systemRed
            case -10.0 ..< -0.1:
                self?.stockStatusLabel.layer.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
                self?.stockChangePercentLabel.textColor = .systemGreen
            default:
                self?.stockStatusLabel.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
                self?.stockChangePercentLabel.textColor = .white
            }
        }
        .store(in: &subscriptions)
    }
    
    // 配置 UI 佈局的方法
    private func configureUI() {
        NSLayoutConstraint.activate([
            // 配置 nameLabel 的佈局
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // 配置 symbolLabel 的佈局
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            symbolLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // 配置 stockPriceLabel 的佈局
            stockPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stockPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stockPriceLabel.widthAnchor.constraint(equalToConstant: 60),
            stockPriceLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // 配置 stockChangePercentLabel 的佈局
            stockChangePercentLabel.trailingAnchor.constraint(equalTo: stockPriceLabel.trailingAnchor),
            stockChangePercentLabel.topAnchor.constraint(equalTo: stockPriceLabel.bottomAnchor),
            stockChangePercentLabel.widthAnchor.constraint(equalToConstant: 120),
            stockChangePercentLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // 配置 stockStatusLabel 的佈局
            stockStatusLabel.trailingAnchor.constraint(equalTo: stockChangePercentLabel.leadingAnchor),
            stockStatusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stockStatusLabel.widthAnchor.constraint(equalToConstant: 80),
            stockStatusLabel.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}

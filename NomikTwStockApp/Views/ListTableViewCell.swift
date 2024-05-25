//
//  ListTableViewCell.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/20.
//

import UIKit
import Combine

class ListTableViewCell: UITableViewCell {
    
    private let padding: CGFloat = 10.0
    
    private var viewModel = StockUpDownViewModels()
    private var subscriptions: Set<AnyCancellable> = []
    
    static let identifier = "ListTableViewCell"
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
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
    
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private let stockChangePercentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(stockStatusLabel)
        contentView.addSubview(stockPriceLabel)
        contentView.addSubview(stockChangePercentLabel)
        
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureNameData(with intoSymbol: String, intoName: String) {
        self.symbolLabel.text = intoSymbol
        self.nameLabel.text = intoName
    }
    
    public func configureStockData(with intoClosePrice: Double, intoChange: Double, intoChangePercent: Double) {
        self.stockPriceLabel.text = "\(intoClosePrice)"
        self.stockChangePercentLabel.text = "\(intoChange) (\(intoChangePercent)%)"
        bindView(with: intoChangePercent)
    }
    
    private func bindView(with changeValue: Double) {
        viewModel.intoChangeValue = changeValue
        self.stockStatusLabel.text = viewModel.stockPriceChange()
        
        viewModel.$colorChange.sink { [weak self] color in
            self?.stockStatusLabel.backgroundColor = color
        }
        .store(in: &subscriptions)
        
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
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            symbolLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stockPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stockPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stockPriceLabel.widthAnchor.constraint(equalToConstant: 60),
            stockPriceLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            stockChangePercentLabel.trailingAnchor.constraint(equalTo: stockPriceLabel.trailingAnchor),
            stockChangePercentLabel.topAnchor.constraint(equalTo: stockPriceLabel.bottomAnchor),
            stockChangePercentLabel.widthAnchor.constraint(equalToConstant: 120),
            stockChangePercentLabel.heightAnchor.constraint(equalToConstant: 30),
            
            stockStatusLabel.trailingAnchor.constraint(equalTo: stockChangePercentLabel.leadingAnchor),
            stockStatusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stockStatusLabel.widthAnchor.constraint(equalToConstant: 80),
            stockStatusLabel.heightAnchor.constraint(equalToConstant: 45),
            
            
        ])
    }

}

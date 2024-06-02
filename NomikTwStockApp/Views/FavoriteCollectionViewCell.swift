//
//  FavoriteCollectionViewCell.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/31.
//

import Foundation
import UIKit


class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteCollectionViewCell"
    
    private let favoriteCode: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2330"
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let favoriteName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "台積電"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let favoritePrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1069.0"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let favoriteChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100.0"
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let favoriteChangePercent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "(10.00%)"
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(favoriteCode)
        contentView.addSubview(favoriteName)
        contentView.addSubview(favoritePrice)
        contentView.addSubview(favoriteChange)
        contentView.addSubview(favoriteChangePercent)
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemRed.cgColor
        contentView.layer.cornerRadius = 10
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            favoriteName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            favoriteCode.leadingAnchor.constraint(equalTo: favoriteName.leadingAnchor),
            favoriteCode.topAnchor.constraint(equalTo: favoriteName.bottomAnchor),
            
            favoriteChange.leadingAnchor.constraint(equalTo: favoriteCode.leadingAnchor),
            favoriteChange.topAnchor.constraint(equalTo: favoriteCode.bottomAnchor, constant: 5),
            
            favoriteChangePercent.leadingAnchor.constraint(equalTo: favoriteChange.leadingAnchor),
            favoriteChangePercent.topAnchor.constraint(equalTo: favoriteChange.bottomAnchor, constant: 1),
            
            favoritePrice.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10),
            favoritePrice.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 20),
        ])
        
    }
}
    

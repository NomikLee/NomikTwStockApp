//
//  UnusualNotetransCollectionViewCell.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/30.
//

import UIKit

class UnusualNotetransCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UnusualNotetransCollectionViewCell"
    
    // MARK: - UI Components
    private let unusualName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let unusualDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    // MARK: - Functions
    public func configure(with name: String, day: String) {
        self.unusualName.text = name
        self.unusualDay.text = day
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .systemBackground
        self.addSubview(unusualName)
        self.addSubview(unusualDay)
        
        NSLayoutConstraint.activate([
            unusualName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            unusualName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            
            unusualDay.topAnchor.constraint(equalTo: unusualName.bottomAnchor, constant: 10),
            unusualDay.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}

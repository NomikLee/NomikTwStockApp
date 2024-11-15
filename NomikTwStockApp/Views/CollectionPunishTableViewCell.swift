//
//  CollectionPunishTableViewCell.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/28.
//

import UIKit

protocol CollectionPushPunishDelegate: AnyObject {
    func pushPunishCollectionCell(_ indexPush: Int)
}

class CollectionPunishTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "CollectionPunishTableViewCell"
    weak var delegate: CollectionPushPunishDelegate?
    
    private let viewModel = StockDataViewModels()
    var punishs: [Punish] = []
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UnusualPunishCollectionViewCell.self, forCellWithReuseIdentifier: UnusualPunishCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemFill
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    public func configurePunish(with punish: [Punish]) {
        self.punishs = punish
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Extension
extension CollectionPunishTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushPunishCollectionCell(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return punishs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnusualPunishCollectionViewCell.identifier, for: indexPath) as? UnusualPunishCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: punishs[indexPath.row].Name, day: punishs[indexPath.row].DispositionMeasures)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.systemRed.cgColor
        return cell
    }
}

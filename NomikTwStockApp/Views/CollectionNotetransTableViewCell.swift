//
//  CollectionNotetransTableViewCell.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/30.
//

import UIKit

protocol CollectionPushNotetransDelegate: AnyObject {
    func pushNotetransCollectionCell(_ notetran: [Notetrans], indexPush: Int)
}

class CollectionNotetransTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionNotetransTableViewCell"
    
    // MARK: - Variables
    weak var delegate: CollectionPushNotetransDelegate?
    private let viewModel = StockDataViewModels()
    var notetrans: [Notetrans] = []
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UnusualNotetransCollectionViewCell.self, forCellWithReuseIdentifier: UnusualNotetransCollectionViewCell.identifier)
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
    public func configureNotetran(with notetran: [Notetrans]) {
        self.notetrans = notetran
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Extension
extension CollectionNotetransTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushNotetransCollectionCell(notetrans, indexPush: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notetrans.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnusualNotetransCollectionViewCell.identifier, for: indexPath) as? UnusualNotetransCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: notetrans[indexPath.row].Name, day: String(notetrans[indexPath.row].RecentlyMetAttentionSecuritiesCriteria.suffix(4)))
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.systemYellow.cgColor
        return cell
    }
}

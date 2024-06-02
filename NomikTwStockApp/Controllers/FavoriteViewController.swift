//
//  FavoriteViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//
import FirebaseFirestore
import UIKit

class FavoriteViewController: UIViewController {
    
    private let searchVC = UISearchController(searchResultsController: SearchViewController())
    
    let dataBase = Firestore.firestore()
    
    private let favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(favoriteCollectionView)
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(didTapUser))
        
        createSearchBar()
        
    }
    
    
    private func writeData(stockCode: String, stockName: String) {
        let doc = dataBase.document("Favorite/TwStock")
        doc.setData([stockCode : stockName])
    }
    
    private func readData() {
        let doc = dataBase.document("Favorite/TwStock")
        doc.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else { return }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoriteCollectionView.frame = view.bounds
    }
    
    @objc func didTapUser() {
        let vc = UserViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
        searchVC.searchBar.delegate = self
    }

}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cSize = self.view.frame.width / 2
        return CGSize(width: cSize - 5, height: cSize/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FavoriteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

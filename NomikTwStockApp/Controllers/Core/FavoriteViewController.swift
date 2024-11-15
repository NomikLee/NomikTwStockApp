//
//  FavoriteViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//
import FirebaseFirestore
import UIKit

class FavoriteViewController: UIViewController {
    
    // MARK: - Variables
    private let searchVC = UISearchController(searchResultsController: SearchViewController())
    
    private let dataBase = Firestore.firestore()
    private lazy var doc = dataBase.document("Favorite/TwStocks")
    private var favoriteCode: [String] = []
    
    private var viewModel = StockDataViewModels()
    
    // MARK: - UI Components
    private let favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        view.addSubview(favoriteCollectionView)
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        
        createSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoriteCollectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData { _ in
            self.favoriteCollectionView.reloadData()
        }
    }
    
    // MARK: - Functions
    private func readData(completion: @escaping ([String]) -> Void){
        doc.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else { return self.doc.setData([:]) }
            
            DispatchQueue.main.async {
                let keysCollection: Dictionary<String, Any>.Keys = data.keys
                self.favoriteCode = Array(keysCollection)
                completion(self.favoriteCode)
            }
        }
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
        searchVC.searchBar.delegate = self
        searchVC.searchResultsUpdater = self
    }
}

// MARK: - Extension
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        
        viewModel.GetQuoteSingle(symbolCode: favoriteCode[indexPath.row]) { [weak self] result in
            switch result {
            case .success(let favoriteData):
                DispatchQueue.main.async {
                    cell.configure(with: favoriteData)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let DetailVC = DetailViewController()
        DetailVC.title = favoriteCode[indexPath.row]
        
        navigationController?.pushViewController(DetailVC, animated: true)
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

extension FavoriteViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text, let resultsController = searchController.searchResultsController as? SearchViewController else {
            return
        }
        DispatchQueue.main.async {
            self.viewModel.GetTickers { result in
                switch result {
                case .success(let searchDatas):
                    if let data = searchDatas.data {
                        if !searchBarText.isEmpty {
                            resultsController.searchResults = data.filter { $0.name == searchBarText || $0.symbol == searchBarText }
                        }
                    }
                    resultsController.searchTableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {}
}

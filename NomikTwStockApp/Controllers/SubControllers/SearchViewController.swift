//
//  SearchViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchResults: [TickersListDatas] = []
    
    public let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchTableView)
        
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let searchSymbol = searchResults[indexPath.row].symbol, let searchName = searchResults[indexPath.row].name {
            cell.textLabel?.text = "\(searchSymbol) \(searchName)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.title = "\(self.searchResults[indexPath.row].symbol ?? "無資料")"
        let navController = UINavigationController(rootViewController: detailVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    
}

//
//  HomeViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import UIKit


class HomeViewController: UIViewController {
    
    var marketData: MarketDataResponse?
    
    private let homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeTableView)
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        homeTableView.tableHeaderView = TwiiHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        
        APIService.shared.quotesCall { result in
            switch result {
            case .success(let marketData):
                self.marketData = marketData
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        if let marketData = marketData {
            var index = indexPath.row
            while index < marketData.data.count {
                let symbol = marketData.data[index].symbol
                if symbol.contains(where: { $0.isLetter }) {
                    index += 1
                } else {
                    cell.configureData(with: symbol, intoName: marketData.data[index].name)
                    return cell
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


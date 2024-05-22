//
//  HomeViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import UIKit


class HomeViewController: UIViewController{
    
    var tapMoversUP: Bool = false
    var tapMoversDown: Bool = false
    var tapVolume: Bool = false
    
    private var viewModel = StockDataViewModels()
    
    private let homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "台灣加權指數"
        view.backgroundColor = .systemBackground
        view.addSubview(homeTableView)
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        let twiiHeaderView = TwiiHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        twiiHeaderView.delegate = self
        homeTableView.tableHeaderView = twiiHeaderView
        
        reloadViewData()
    }
    
    private func reloadViewData() {
        viewModel.GetMoversUp { _ in
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
        
        viewModel.GetMoversDown { _ in
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
        
        viewModel.GetVolumes { _ in
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, TwiiHeaderViewDelegate {
    
    func twiiHeaderViewDidTapMoversUP() {
        tapMoversUP = true
        tapMoversDown = false
        tapVolume = false
        self.homeTableView.reloadData()
    }

    func twiiHeaderViewDidTapMoversDown() {
        tapMoversUP = false
        tapMoversDown = true
        tapVolume = false
        self.homeTableView.reloadData()
    }

    func twiiHeaderViewDidTapVolume() {
        tapMoversUP = false
        tapMoversDown = false
        tapVolume = true
        self.homeTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.configureData(with: viewModel.moversUPData?.data[indexPath.row].symbol ?? "", intoName: viewModel.moversUPData?.data[indexPath.row].name ?? "")
        
        if tapMoversUP {
            cell.configureData(with: viewModel.moversUPData?.data[indexPath.row].symbol ?? "", intoName: viewModel.moversUPData?.data[indexPath.row].name ?? "")
        }else if tapMoversDown{
            cell.configureData(with: viewModel.moversDOWNData?.data[indexPath.row].symbol ?? "", intoName: viewModel.moversDOWNData?.data[indexPath.row].name ?? "")
        }else if tapVolume {
            cell.configureData(with: viewModel.volumesData?.data[indexPath.row].symbol ?? "", intoName: viewModel.volumesData?.data[indexPath.row].name ?? "")
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

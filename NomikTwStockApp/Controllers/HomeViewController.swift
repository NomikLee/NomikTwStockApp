//
//  HomeViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import UIKit


class HomeViewController: UIViewController {
    
    var timer: Timer?
    
    private var tapMoversUP: Bool = false
    private var tapMoversDown: Bool = false
    private var tapVolume: Bool = false
    
    private var viewModel = StockDataViewModels()
    
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
        
        let twiiHeaderView = TwiiHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        twiiHeaderView.delegate = self
        homeTableView.tableHeaderView = twiiHeaderView
        
        reloadViewData()
        startTimer()
        
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.reloadViewData()
        })
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
        
        switch true {
        case tapMoversUP:
            cell.configureNameData(with: viewModel.moversUPData?.data[indexPath.row].symbol ?? "", intoName: viewModel.moversUPData?.data[indexPath.row].name ?? "")
            cell.configureStockData(with: viewModel.moversUPData?.data[indexPath.row].closePrice ?? 0.0, intoChange: viewModel.moversUPData?.data[indexPath.row].change ?? 0.0, intoChangePercent: viewModel.moversUPData?.data[indexPath.row].changePercent ?? 0.0)
        case tapMoversDown:
            cell.configureNameData(with: viewModel.moversDOWNData?.data[indexPath.row].symbol ?? "", intoName: viewModel.moversDOWNData?.data[indexPath.row].name ?? "")
            cell.configureStockData(with: viewModel.moversDOWNData?.data[indexPath.row].closePrice ?? 0.0, intoChange: viewModel.moversDOWNData?.data[indexPath.row].change ?? 0.0, intoChangePercent: viewModel.moversDOWNData?.data[indexPath.row].changePercent ?? 0.0)
        case tapVolume:
            cell.configureNameData(with: viewModel.volumesData?.data[indexPath.row].symbol ?? "", intoName: viewModel.volumesData?.data[indexPath.row].name ?? "")
            cell.configureStockData(with: viewModel.volumesData?.data[indexPath.row].closePrice ?? 0.0, intoChange: viewModel.volumesData?.data[indexPath.row].change ?? 0.0, intoChangePercent: viewModel.volumesData?.data[indexPath.row].changePercent ?? 0.0)
        default:
            cell.configureNameData(with: viewModel.moversUPData?.data[indexPath.row].symbol ?? "", intoName: viewModel.moversUPData?.data[indexPath.row].name ?? "")
            cell.configureStockData(with: viewModel.moversUPData?.data[indexPath.row].closePrice ?? 0.0, intoChange: viewModel.moversUPData?.data[indexPath.row].change ?? 0.0, intoChangePercent: viewModel.moversUPData?.data[indexPath.row].changePercent ?? 0.0)
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailVC = DetailViewController()
        DetailVC.title = "\(viewModel.moversUPData?.data[indexPath.row].name ?? "無資料")"
        navigationController?.pushViewController(DetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//
//  UnusualViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import UIKit

class UnusualViewController: UIViewController {
    
    // MARK: - Variables
    private let viewModel = StockDataViewModels()
    
    let setUnusualTitle: [String] = ["⚠️ 注意股", "🛑 處置股"]
    
    // MARK: - UI Components
    private let unusualTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionPunishTableViewCell.self, forCellReuseIdentifier: CollectionPunishTableViewCell.identifier)
        tableView.register(CollectionNotetransTableViewCell.self, forCellReuseIdentifier: CollectionNotetransTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(unusualTableView)
        view.backgroundColor = .systemBackground
        
        unusualTableView.delegate = self
        unusualTableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        unusualTableView.frame = view.bounds
        
    }

}

// MARK: - Extension
extension UnusualViewController: UITableViewDelegate, UITableViewDataSource, CollectionPushPunishDelegate, CollectionPushNotetransDelegate {
    func pushNotetransCollectionCell(_ notetran: [Notetrans], indexPush: Int) {
        let alert = UIAlertController(title: "\(notetran[indexPush].Code) \(notetran[indexPush].Name)", message: "\(notetran[indexPush].RecentlyMetAttentionSecuritiesCriteria)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func pushPunishCollectionCell(_ indexPush: Int) {
        let vc = UnusualDetailViewController()
        vc.configureUnusualDetail(with: indexPush)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return setUnusualTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionNotetransTableViewCell.identifier, for: indexPath) as? CollectionNotetransTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            viewModel.GetNotetrans { [weak self] result in
                switch result {
                case .success(let notetrans):
                    cell.configureNotetran(with: notetrans)
                case .failure(let error):
                    print(error)
                }
            }
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionPunishTableViewCell.identifier, for: indexPath) as? CollectionPunishTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            viewModel.GetPunish { [weak self] result in
                switch result {
                case .success(let punish):
                    cell.configurePunish(with: punish)
                case .failure(let error):
                    print(error)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return setUnusualTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        
        if section == 0 {
            header.textLabel?.textColor = .yellow
        }else {
            header.textLabel?.textColor = .red
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

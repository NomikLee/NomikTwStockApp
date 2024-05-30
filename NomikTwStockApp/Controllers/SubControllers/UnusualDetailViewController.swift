//
//  UnusualDetailViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/30.
//

import UIKit

class UnusualDetailViewController: UIViewController {
    
    private let viewModel = StockDataViewModels()
    
    private let titleAndCode: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .systemOrange
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let measuresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let scrollLabelView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleAndCode)
        view.addSubview(periodLabel)
        view.addSubview(measuresLabel)
        view.addSubview(scrollLabelView)
        scrollLabelView.addSubview(detailLabel)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollLabelView.contentSize = detailLabel.bounds.size
    }
    
    public func configureUnusualDetail(with indexPush: Int) {
        viewModel.GetPunish { [weak self] result in
            switch result {
            case .success(let unusualDetail):
                DispatchQueue.main.async {
                    self?.titleAndCode.text = "\(unusualDetail[indexPush].Code) \(unusualDetail[indexPush].Name)"
                    self?.periodLabel.text = "處置日期: \(unusualDetail[indexPush].DispositionPeriod)"
                    self?.measuresLabel.text = "處置次數: \(unusualDetail[indexPush].DispositionMeasures)"
                    self?.detailLabel.text = "\(unusualDetail[indexPush].Detail)"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureUI() {
        
        NSLayoutConstraint.activate([
            titleAndCode.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleAndCode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            periodLabel.topAnchor.constraint(equalTo: titleAndCode.bottomAnchor, constant: 10),
            periodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            measuresLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 10),
            measuresLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollLabelView.topAnchor.constraint(equalTo: measuresLabel.bottomAnchor, constant: 30),
            scrollLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollLabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            detailLabel.topAnchor.constraint(equalTo: scrollLabelView.topAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: scrollLabelView.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: scrollLabelView.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: scrollLabelView.bottomAnchor),
            
            detailLabel.widthAnchor.constraint(equalTo: scrollLabelView.widthAnchor)
        ])
        
        
    }

}

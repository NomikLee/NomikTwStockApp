//
//  DetailViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let testText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "還沒做好"
        label.font = .systemFont(ofSize: 30)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testText)
        view.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            testText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testText.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}

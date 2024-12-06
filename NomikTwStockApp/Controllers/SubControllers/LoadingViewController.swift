//
//  LoadingViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/12/3.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private let loadingView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(loadingView)
        
        configureUI()
    }
    
    private func configureUI() {
        guard let data = NSDataAsset(name: "loading2")?.data else { return }
        let cfData = data as CFData
        CGAnimateImageDataWithBlock(cfData, nil) { _, cgImage, _ in
            self.loadingView.image = UIImage(cgImage: cgImage)
        }
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 350),
            loadingView.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
}

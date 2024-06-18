//
//  CoverViewController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/6/16.
//

import UIKit

class CoverViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coverImage")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("START", for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(enterButton)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        applyGradientToButton()
    }
    
    @objc func didTapHome() {
        let tabbarVc = MainTabbarController()
        tabbarVc.modalPresentationStyle = .fullScreen
        present(tabbarVc, animated: true)
    }
    
    private func configureUI() {
        enterButton.addTarget(self, action: #selector(didTapHome), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.enterButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
        
        NSLayoutConstraint.activate([
            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            enterButton.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    private func applyGradientToButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = enterButton.bounds
        gradientLayer.colors = [UIColor.systemOrange.cgColor, UIColor.systemPurple.cgColor]
        enterButton.layer.insertSublayer(gradientLayer, at: 0)
    }
}

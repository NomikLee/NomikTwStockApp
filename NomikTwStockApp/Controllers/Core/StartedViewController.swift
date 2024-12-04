//
//  StartedViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/20.
//

import UIKit
import FirebaseAuth

class StartedViewController: UIViewController {
    
    // MARK: - Variables
    var timer: Timer?
    var currentText: String = ""
    var fullText: String = "Are you ready with your strategy to land your great deal?"
    var currentIndex: Int = 0
    
    // MARK: - UI Components
    private let marqueeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg2")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started", for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(enterButton)
        view.addSubview(marqueeTitle)
        
        configureUI()
        setMarquee()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        applyGradientToButton()
    }
    
    // MARK: - Functions
    private func applyGradientToButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = enterButton.bounds
        gradientLayer.colors = [UIColor.systemOrange.cgColor, UIColor.systemPurple.cgColor]
        enterButton.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setMarquee() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMarquee), userInfo: nil, repeats: true)
    }
    
    private func loadMainTabBar(from loadingVC: UIViewController) {
        let tabbarVC = MainTabbarController()
        tabbarVC.modalPresentationStyle = .fullScreen
        loadingVC.present(tabbarVC, animated: true)
    }
    
    // MARK: - Selectors
    @objc private func didTapStart() {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overFullScreen
        present(loadingVC, animated: true)
        
        //延遲2秒
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            self.loadMainTabBar(from: loadingVC)
        }
    }
    
    @objc func updateMarquee() {
        if currentIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
            currentText.append(fullText[index])
            marqueeTitle.text = currentText
            currentIndex += 1
        }else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        enterButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.enterButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
        
        NSLayoutConstraint.activate([
            marqueeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            marqueeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            marqueeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            marqueeTitle.heightAnchor.constraint(equalToConstant: 150),
            
            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            enterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300),
            enterButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

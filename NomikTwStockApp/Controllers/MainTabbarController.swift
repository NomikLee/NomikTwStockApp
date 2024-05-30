//
//  MainTabbarController.swift
//  NomikTwStockApp
//
//  Created by Pinocchio on 2024/5/19.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        let favoriteVC = FavoriteViewController()
        let strategyVC = StrategyViewController()
        let unusualVC = UnusualViewController()
        
        homeVC.title = "📈台股100排行"
        favoriteVC.title = "❤️自選股"
        strategyVC.title = "♟️老余交易策略"
        unusualVC.title = "注意處置股"
        
        
        let vc1 = UINavigationController(rootViewController: homeVC)
        let vc2 = UINavigationController(rootViewController: favoriteVC)
        let vc3 = UINavigationController(rootViewController: strategyVC)
        let vc4 = UINavigationController(rootViewController: unusualVC)
        
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
//        vc4.navigationBar.prefersLargeTitles = true
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        vc3.tabBarItem.image = UIImage(systemName: "graduationcap")
        vc4.tabBarItem.image = UIImage(systemName: "exclamationmark.triangle")
        
        vc1.tabBarItem.title = "主頁"
        vc2.tabBarItem.title = "自選股"
        vc3.tabBarItem.title = "交易策略"
        vc4.tabBarItem.title = "注意處置股"
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
    }
}

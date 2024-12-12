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
        let calculateVC = CalculateViewController()
        
        homeVC.title = "台股排行"
        favoriteVC.title = "自選股"
        calculateVC.title = "複利計算機"
        
        let vc1 = UINavigationController(rootViewController: homeVC)
        let vc2 = UINavigationController(rootViewController: favoriteVC)
        let vc3 = UINavigationController(rootViewController: calculateVC)
        
        // 設置大標題
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true

        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        vc3.tabBarItem.image = UIImage(systemName: "square.grid.3x3.middle.filled")
        
        vc1.tabBarItem.title = ""
        vc2.tabBarItem.title = ""
        vc3.tabBarItem.title = ""
        
        tabBar.tintColor = .systemOrange
        
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
}

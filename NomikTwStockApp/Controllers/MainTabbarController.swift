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
        let unusualVC = UnusualViewController()
        
        homeVC.title = "台股排行"
        favoriteVC.title = "自選股"
        unusualVC.title = "注意處置股"
        
        
        let vc1 = UINavigationController(rootViewController: homeVC)
        let vc2 = UINavigationController(rootViewController: favoriteVC)
        let vc3 = UINavigationController(rootViewController: unusualVC)
        
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
//        vc4.navigationBar.prefersLargeTitles = true
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        vc3.tabBarItem.image = UIImage(systemName: "exclamationmark.triangle")
        
        vc1.tabBarItem.title = "主頁"
        vc2.tabBarItem.title = "自選股"
        vc3.tabBarItem.title = "注意處置股"
        
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
}

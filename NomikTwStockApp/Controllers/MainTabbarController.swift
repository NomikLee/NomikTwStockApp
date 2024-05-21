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
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: FavoriteViewController())
        let vc3 = UINavigationController(rootViewController: StrategyViewController())
        let vc4 = UINavigationController(rootViewController: UnusualViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        vc3.tabBarItem.image = UIImage(systemName: "graduationcap")
        vc4.tabBarItem.image = UIImage(systemName: "exclamationmark.triangle")
        
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "Favorite"
        vc3.tabBarItem.title = "Strategy"
        vc4.tabBarItem.title = "Unusual"
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        
    }
}

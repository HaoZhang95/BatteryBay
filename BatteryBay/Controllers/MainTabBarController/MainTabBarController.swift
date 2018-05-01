//
//  MainTabBarController.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 24/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
    }
    
    fileprivate func setupViewControllers() {
        
        let mainPageViewController = templateViewController(unselectedImage: #imageLiteral(resourceName: "home"), title: "Main page", rootViewController: MainPageViewController())
        
        // Todo: Emma and Mikeal to implement viewController for userProfile
        
        let userProfileController = templateViewController(unselectedImage: #imageLiteral(resourceName: "man-user"), title: "Profile", rootViewController: UIViewController())
        
        tabBar.tintColor = UIColor.movieTintColor()
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.mainColor()
        
        viewControllers = [mainPageViewController, userProfileController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func templateViewController(unselectedImage: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> CustomNavigationController {
        let viewController = rootViewController
        let navController = CustomNavigationController(rootViewController: viewController)
        let font = UIFont(name: "Avenir-Heavy", size: 9)!
        navController.tabBarItem.image = unselectedImage
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : font], for: .normal)
        navController.tabBarItem.title = title
        return navController
    }
    
}

//
//  CustomTabBar.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import Foundation
import UIKit
import ESTabBarController_swift

class TabbarProvider{
    
    // MARK: - Init TabBar
    static func initTabbar() -> ESTabBarController{
        let tabbarController = ESTabBarController()
        if let tabBar = tabbarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .automatic
            tabBar.layer.cornerRadius = 20
            tabBar.layer.masksToBounds = true
            tabBar.tabBarHeight = 80
            tabBar.shadowImage = nil
            tabBar.backgroundColor = ColorName.black.color
        }
        let v1 = HomeViewController()
        let v2 = SearchViewController()
        let v3 = ShowtimesViewController()
        let v4 = ProfileViewController()
        
        v1.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        v2.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        v3.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar.fill"))
        v4.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
    
        tabbarController.viewControllers = [v1, v2, v3, v4]
        
        return tabbarController
    }
}

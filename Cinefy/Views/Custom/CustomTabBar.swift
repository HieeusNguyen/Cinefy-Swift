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
        
        let home = HomeViewController()
        let search = SearchViewController()
        let showtimes = ShowtimesViewController()
        let profile = ProfileViewController()
        
        let homeNav = UINavigationController(rootViewController: home)
        let searchNav = UINavigationController(rootViewController: search)
        let showtimesNav = UINavigationController(rootViewController: showtimes)
        let profileNav = UINavigationController(rootViewController: profile)
        
        home.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        search.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        showtimes.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar.fill"))
        profile.tabBarItem = ESTabBarItem.init( image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
    
        tabbarController.viewControllers = [homeNav, searchNav, showtimesNav, profileNav]
        
        return tabbarController
    }
}

//
//  DashboardViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/27/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        
        let homeStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        var vcArray: [UIViewController] = []
        
        if let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            let homeNav = UINavigationController(rootViewController: homeVC) // back will work till this VC only
            homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: nil)
            vcArray.append(homeNav)
        }
        
        let settingsStoryboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        if let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            let settingsNav = UINavigationController(rootViewController: settingsVC)
            settingsNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: nil)
            vcArray.append(settingsNav)
        }
        
        viewControllers = vcArray

    }
  
}

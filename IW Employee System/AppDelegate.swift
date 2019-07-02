//
//  AppDelegate.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/25/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = UserDefaults.standard
        guard let _ = defaults.object(forKey: Constants.UserDefaultKeys.userInfo) else {
            setupAccountStoryboard()
            return true
        }
        setupDashboard()
        return true
    }
    
    private func setupDashboard(){
        let appFunctionalityStoryboard = UIStoryboard(name: "AppFunctionalityStoryboard", bundle: nil)
        if let appTabBarVC = appFunctionalityStoryboard.instantiateViewController(withIdentifier: "AppTabBarController") as? AppTabBarController {
            window?.rootViewController = appTabBarVC
            window?.makeKeyAndVisible()
        }
    }
    
    private func setupAccountStoryboard(){
        let accountStoryboard = UIStoryboard(name: "AccountStoryboard", bundle: nil)
        if let loginVC = accountStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? UIViewController {
            let navController = UINavigationController(rootViewController: loginVC)
            navController.setNavigationBarHidden(true, animated: true)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }
    
}


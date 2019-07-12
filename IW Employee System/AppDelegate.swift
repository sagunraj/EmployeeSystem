//
//  AppDelegate.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/25/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance()?.clientID = "786635764254-a09e3c9sj307977j484mu383rjh0l69f.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        checkForUserDefaults()
        return true
    }
    
    private func checkForUserDefaults() {
        let defaults = UserDefaults.standard
        guard let _ = defaults.object(forKey: Constants.UserDefaultKeys.userInfo) else {
            setupAccountStoryboard()
            return
        }
        setupDashboard()
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


// MARK: - <#GIDSignInDelegate#>
extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            if let googleId = user.userID,
                let firstName = user.profile.givenName,
                let lastName = user.profile.familyName,
                let email = user.profile.email {
                let userObj = User(id: -1, firstName: firstName, lastName: lastName, emailAddress: email, designation: "None", profilePic: "None", googleId: googleId)
                UserDefaultsHelper.setUserDefaults(with: userObj, forKey: Constants.UserDefaultKeys.userInfo)
                checkForUserDefaults()
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
}

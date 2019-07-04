//
//  LoginViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/25/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class LoginViewController: KeyboardAvoidingViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginBtn: UIButton!
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kaScrollView = scrollView
        setTextFields()
    }
    
    private func setTextFields(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.returnKeyType = UIReturnKeyType.next // Next button appears in place of Done in keyboard
        passwordTextField.returnKeyType = UIReturnKeyType.go // Go button appears in place of Done in keyboard
        
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    private func loadUserDetailsFromAPI(){
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string: "https://jsonblob.com/api/a01f2cd3-9c8d-11e9-8e75-a9fe9bdf45e7") else { return }
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard let resData = data, response != nil, error == nil else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseObj = try decoder.decode(UserResponse.self, from: resData)
                self.user = responseObj.user
                
                UserDefaultsHelper.setUserDefaults(with: self.user!, forKey: Constants.UserDefaultKeys.userInfo)
                
                let queue = OperationQueue.main
                queue.addOperation {
                    self.loadAppFunctionalityStoryboard()
                }
            } catch {
                print("Something went wrong.")
            }
        }
        task.resume()
    }
    
    
    private func loadAppFunctionalityStoryboard() {
        
        let appFunctionalityStoryboard = UIStoryboard(name: "AppFunctionalityStoryboard", bundle: nil)
        if let tabBarVC = appFunctionalityStoryboard.instantiateViewController(withIdentifier: "AppTabBarController") as? AppTabBarController {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate // taken reference of AppDelegate to access window variable for setting up the rootViewController after login
            let window = appDelegate.window
            
            window?.rootViewController = tabBarVC
            window?.makeKeyAndVisible()
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            self.onLoginTap(loginBtn)
        }
        else {
            passwordTextField.becomeFirstResponder()
        }
        return false
    }
}

extension LoginViewController {
    
    @IBAction func onSignUpTap(_ sender: UIButton) {
        guard let signUpVC = SignUpViewController.getInstance() else { return }
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func onLoginTap(_ sender: UIButton) {
        let loginModel = LoginModel(email: emailTextField.text.unWrapped.trimmed , password: passwordTextField.text.unWrapped.trimmed)
        
        if FormValidation.requiredValidation(loginModel.email) && FormValidation.requiredValidation(loginModel.password) {
            if FormValidation.emailValidation(loginModel.email) {
                loadUserDetailsFromAPI()
            }
        } else {
            showAlert(alertTitle: StringConstants.strings["error"]!, alertMessage: StringConstants.strings["required"]!, alertActionTitle: StringConstants.strings["signUpAlertActionTitle"]!, handler: { _ in })
        }
    
    }
    
    
}

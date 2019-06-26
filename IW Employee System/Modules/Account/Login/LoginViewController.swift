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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kaScrollView = scrollView
        setTextFields()
    }
    
    private func setTextFields(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
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
            
        }
        else {
            showAlert(alertTitle: StringConstants.strings["error"]!, alertMessage: StringConstants.strings["required"]!, alertActionTitle: StringConstants.strings["signUpAlertActionTitle"]!, handler: { _ in })
        }
    
    }
    
}

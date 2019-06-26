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
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kaScrollView = scrollView
    }
    
    private func setTextFields(){
        emailTextField.delegate = self
        passwordTextFIeld.delegate = self
        
        emailTextField.autocorrectionType = .no
        passwordTextFIeld.autocorrectionType = .no
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    @IBAction func onSignUpTap(_ sender: UIButton) {
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}

//
//  SignUpViewController.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/25/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

class SignUpViewController: KeyboardAvoidingViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var fNameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    @IBOutlet var phoneTxtField: UITextField!
    @IBOutlet var locationTxtField: UITextField!
    
    @IBOutlet weak var agreeSwitch: UISwitch!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialSwitchValue()
        setupView()
        setTxtFields()
    }
    
    private func setupView() {
        kaScrollView = scrollView
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setInitialSwitchValue(){
        agreeSwitch.isOn = false
        agreeSwitch.setOn(false, animated: true)
    }
    
    private func setTxtFields() {
        fNameTxtField.delegate = self
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        phoneTxtField.delegate = self
        locationTxtField.delegate = self
        
        fNameTxtField.autocorrectionType = .no
        emailTxtField.autocorrectionType = .no
        passwordTxtField.autocorrectionType = .no
        phoneTxtField.autocorrectionType = .no
        locationTxtField.autocorrectionType = .no
    }
    
    private func createAlertAfterSignUp() {
        let alertController = UIAlertController(title: StringConstants.signUpAlertControllerTitle,
                                                message: StringConstants.signUpAlertControllerMessage,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: StringConstants.signUpAlertActionTitle,
                                        style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
}

// MARK: - IBActions of SignUpViewController
extension SignUpViewController {
    
    @IBAction func onSwitchTap(_ sender: UISwitch) {
        agreeSwitch.setOn(!agreeSwitch.isOn, animated: true)
    }
    
    @IBAction func onSignUpTap(_ sender: UIButton) {
       createAlertAfterSignUp()
    }
    
}

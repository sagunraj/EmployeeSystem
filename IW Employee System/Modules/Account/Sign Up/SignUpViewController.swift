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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kaScrollView = scrollView
        setTxtFields()
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
    
}

//
//  AppTextField.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/12/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit

enum FieldType {
    case normal
    case password
    case date
    
}

class AppTextField: UITextField {

    var fieldType: FieldType = .normal {
        didSet {
            self.isSecureTextEntry = fieldType == .password
        }
    }
    
    var canBeEmpty: Bool = true
    var descriptionTxt: String = "Field"

}

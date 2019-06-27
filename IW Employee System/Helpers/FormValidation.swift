//
//  FormValidation.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/26/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation

struct FormValidation {
    
    static func requiredValidation(_ value: String) -> Bool {
        return !value.isEmpty
    }
    
    static func emailValidation(_ value: String) -> Bool {
        let REGEX = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: value)
    }
}

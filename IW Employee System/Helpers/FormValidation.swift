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
        if value.count > 0 {
            return true
        }
        return false
    }
    
}

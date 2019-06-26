//
//  IntExtension.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/26/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation

extension Int {
    
    var likes: String {
        if self % 1000 > 0 {
            return "\((self / 1000)) likes"
        } else {
            return "\(self) likes"
        }
    }
}

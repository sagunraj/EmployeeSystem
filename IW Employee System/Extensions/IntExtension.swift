//
//  IntExtension.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/26/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Int {
    
    var unWrapped: Int {
        return self ?? 0
    }
 
}

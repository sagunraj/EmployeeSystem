//
//  StringExtension.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/26/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation

extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var intValue: Int { return Int(self) ?? 0 }
}

extension Optional where Wrapped == String {
    
    var unWrapped: String { return self ?? "" }
    
}

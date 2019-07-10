//
//  CLPlacemarkExtension.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/10/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation
import CoreLocation

extension Optional where Wrapped == CLPlacemark {
    
    var unWrapped: CLPlacemark {
        return self  ?? CLPlacemark()
    }
    
    
}

extension CLPlacemark {
    
    var formattedAddress: String {
        var generatedAddressArr = [String]()
        
        if let subLocality = subLocality {
            generatedAddressArr.append(subLocality)
        }
        if let locality = locality {
            generatedAddressArr.append(locality)
        }
        if let country = country {
            generatedAddressArr.append(country)
        }
        
        return generatedAddressArr.isEmpty ? "Untitled location" :  generatedAddressArr.joined(separator: ", ")
    }
    
}


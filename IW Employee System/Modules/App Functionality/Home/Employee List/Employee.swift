//
//  UserModel.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/28/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import UIKit
import MapKit

struct EmployeeListResponse: Codable {
    var message: String
    var employees: [Employee]
}

struct Employee: Codable {
    var id: Int
    var name: String
    var emailAddress: String
    var primaryNumber: String
    var designation: String
    var team: Team
    var dob: String?
    var image: Data?
//    var image: String? // FOR BASE64
    var address: Address?
}

struct Team: Codable {
    var id: Int
    var name: String
    var avatar: String
    var members: Int
}

struct Address: Codable {
    var latitude: Double
    var longitude: Double
    var formattedAddress: String
}


//class Location: NSObject, MKAnnotation {
//    let coordinate: CLLocationCoordinate2D
//    let title: String?
//    let subtitle: String?
//
//    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//    }
//}

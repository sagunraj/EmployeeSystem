//
//  User.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/2/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation


struct UserResponse: Codable {
    var user: User
    var message: String
}


struct User: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var emailAddress: String
    var designation: String
    var profilePic: String
}

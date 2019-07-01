//
//  UserModel.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 6/28/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation

struct EmployeeListResponse: Codable {
    var message: String
    var employees: [Employee]
}

struct Employee: Codable {
    var name: String
    var emailAddress: String
    var primaryNumber: String
    var designation: String
    var team: Team
}

struct Team: Codable {
    var id: Int
    var name: String
    var avatar: String
    var members: Int
}

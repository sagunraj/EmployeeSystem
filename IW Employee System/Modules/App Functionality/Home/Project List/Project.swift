//
//  Projects.swift
//  IW Employee System
//
//  Created by Sagun Raj Lage on 7/1/19.
//  Copyright © 2019 Sagun Raj Lage. All rights reserved.
//

import Foundation

struct ProjectListResponse: Codable {
    var message: String
    var projects: [Project]
}

struct Project: Codable {
    var name: String
    var status: String
    var totalMembers: Int
    var image: String
    
}

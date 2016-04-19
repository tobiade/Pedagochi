//
//  User.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 17/04/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation

class User {
    static let sharedInstance = User()
    
    var firstName: String? = "Sarah"
    var lastName: String?
    var username: String?
    var age: Int?
    var weight: Double?
    var emailAddress: String?
}
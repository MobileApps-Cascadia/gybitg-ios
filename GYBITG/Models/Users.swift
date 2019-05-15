//
//  Users.swift
//  GYBITG
//
//  Created by Student Account on 5/2/19.
//

import Foundation

struct Users {
    
    let userId: String // unique id for the user and must be their email address
    let password: String // hash of the password entered by the user
    let createDate: Date // timestamp of when user record was created
    let lastLoginDate: Date // timestamp of last login by Athlete
    let firstName: String? // first name of Athlete
    let lastName: String? // last name of Athlete
    
    init(userId: String, password: String, createDate: Date, lastLoginDate: Date, firstName: String? = "", lastName: String? = "") {
        self.userId = userId
        self.password = password
        self.createDate = createDate
        self.lastLoginDate = lastLoginDate
        self.firstName = firstName
        self.lastName = lastName
    }
}

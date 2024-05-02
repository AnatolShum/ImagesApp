//
//  AuthUser.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import Foundation

class AuthUser {
    let id: String
    let email: String
    let isEmailVerified: Bool
    
    init(id: String, email: String, isEmailVerified: Bool) {
        self.id = id
        self.email = email
        self.isEmailVerified = isEmailVerified
    }
}

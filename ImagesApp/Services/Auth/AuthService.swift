//
//  AuthService.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation

class AuthService: AuthProviderProtocol {
    private let provider: AuthProviderProtocol
    
    init() {
        self.provider = AuthProvider()
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        provider.signIn(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        provider.createUser(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        provider.signOut { result in
            completion(result)
        }
    }
    
    
}

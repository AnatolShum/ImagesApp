//
//  AuthProvider.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation
import FirebaseAuth

class AuthProvider: AuthProviderProtocol {
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    
}

//
//  AuthProvider.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation
import FirebaseAuth

class AuthProvider: AuthProviderProtocol {
    func signIn(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let result {
                completion(.success(()))
            }
            
            if let error {
                completion(.failure(error))
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let result {
                completion(.success(()))
            }
            
            if let error {
                completion(.failure(error))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}

//
//  AuthProviderProtocol.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation

protocol AuthProviderProtocol {
    var currentUser: AuthUser? { get }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void)
    func createUser(email: String, password: String, completion: @escaping (Error?) -> Void)
    func signOut(completion: @escaping (Error?) -> Void)
    func sendEmailVerification(completion: @escaping (Error?) -> Void)
    func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void)
    func addStateDidChangeListener(completion: @escaping (String?) -> Void)
    func googleSignIn(completion: @escaping (Error?) -> Void)
    func googleSignOut()
}

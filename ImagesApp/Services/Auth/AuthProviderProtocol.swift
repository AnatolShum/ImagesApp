//
//  AuthProviderProtocol.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation

protocol AuthProviderProtocol {
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void)
    func createUser(email: String, password: String, completion: @escaping (Error?) -> Void)
    func signOut(completion: @escaping (Error?) -> Void)
}

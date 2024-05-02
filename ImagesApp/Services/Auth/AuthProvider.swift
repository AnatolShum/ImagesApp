//
//  AuthProvider.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthProvider: AuthProviderProtocol {
    private var handler: AuthStateDidChangeListenerHandle?
    
    var currentUser: AuthUser? {
        guard let user = Auth.auth().currentUser else { return nil }
        
        let authUser = AuthUser(
            id: user.uid,
            email: user.email ?? "N/A",
            isEmailVerified: user.isEmailVerified)
        
        return authUser
    }
    
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
    
    func sendEmailVerification(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if let error {
                completion(error)
            } else {
                completion(nil)
            }
        })
    }
    
    func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func addStateDidChangeListener(completion: @escaping (String?) -> Void) {
        self.handler = Auth.auth().addStateDidChangeListener { _, user in
            completion(user?.uid)
        }
    }
    
    private enum GErrors: Error {
        case noClientID
        case noScene
        case noController
        case badResult
    }
    
    func googleSignIn(completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(GErrors.noClientID)
            return }
        
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            completion(GErrors.noScene)
            return }
        guard let rootViewController = scene.windows.first?.rootViewController else {
            completion(GErrors.noController)
            return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error {
                completion(error)
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(GErrors.badResult)
                return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error {
                    completion(error)
                }
            }
        }
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
}

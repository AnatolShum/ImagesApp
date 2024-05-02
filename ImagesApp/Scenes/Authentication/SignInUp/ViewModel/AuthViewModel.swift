//
//  AuthViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation
import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isButtonDisable: Bool = true
    
    private let authService = AuthService()
    private var cancellable: AnyCancellable?
    
    var isVerified: Bool? {
        return authService.currentUser?.isEmailVerified
    }
    
    init() {
        let combined = $email.combineLatest($password)
        
        self.cancellable = combined
            .map { email, password in
                guard ValidateManager.shared.validateEmail(email),
                      ValidateManager.shared.validatePassword(password) else {
                    return true
                }
                
                return false
            }
            .assign(to: \.isButtonDisable, on: self)
    }
    
    func viewTitle(_ state: AuthViewState) -> LocalizedStringKey {
        switch state {
        case .signIn:
            return "signIn"
        case .singUp:
            return "signUp"
        }
    }
    
    func chooseStateTitle(_ state: AuthViewState) -> LocalizedStringKey {
        switch state {
        case .signIn:
            return "createAccount"
        case .singUp:
            return "login"
        }
    }
    
    func signButtonAction(_ state: AuthViewState) {
        switch state {
        case .signIn:
            signIn()
        case .singUp:
            signUp ()
        }
    }
    
    private func signIn() {
        authService.signIn(email: email, password: password) { [weak self] error in
            if let error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            }
        }
    }
    
    private func signUp () {
        authService.createUser(email: email, password: password) { [weak self] error in
            if let error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            }
        }
    }
    
    func signInGoogle() {
        authService.googleSignIn { [weak self] error in
            if let error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            }
        }
    }
    
}

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
    
    init() {
        let combined = $email.combineLatest($password)
        
        self.cancellable = combined
            .map { [weak self] email, password in
                guard let self else {
                    return true
                }
                
                guard self.validateEmail(email), self.validatePassword(password) else {
                    return true
                }
                
                return false
            }
            .assign(to: \.isButtonDisable, on: self)
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword(_ password: String) -> Bool {
        guard !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 8 else {
            return false
        }
        
        return true
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
}

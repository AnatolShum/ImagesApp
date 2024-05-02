//
//  ForgotPassViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import Foundation
import Combine

class ForgotPassViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isButtonDisable: Bool = true
    
    private var authService: AuthService?
    private var cancellable: AnyCancellable?
    
    init() {
        self.cancellable = $email
            .map { email in
                guard ValidateManager.shared.validateEmail(email) else { return true }
                
                return false
            }
            .assign(to: \.isButtonDisable, on: self)
    }
    
    func sendPasswordReset(completion: @escaping () -> ()) {
        authService = AuthService()
        authService?.sendPasswordReset(email: email, completion: { [weak self] error in
            if let error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            } else {
                completion()
            }
        })
    }
}

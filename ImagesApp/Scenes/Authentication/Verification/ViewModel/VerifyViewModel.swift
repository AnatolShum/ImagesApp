//
//  VerifyViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import Foundation

class VerifyViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isButtonDisable: Bool = true
    @Published var buttonTitle: String = "Resend after 60 seconds"
    
    private var authService = AuthService()
    
    init() {
        sendEmailVerification()
    }
 
    func updateButtonParams(_ counter: Int) {
        if counter > 0 {
            isButtonDisable = true
            buttonTitle = "Resend after \(counter) seconds"
        } else {
            isButtonDisable = false
            buttonTitle = "Send"
        }
    }
    
    func sendEmailVerification() {
        authService.sendEmailVerification { [weak self] error in
            if let error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            }
        }
    }
    
    func signOut() {
        authService.signOut { [weak self] error in
            if let error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            }
        }
    }
    
}

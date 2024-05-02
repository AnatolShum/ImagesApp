//
//  SettingsViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    private var authService: AuthService?
    
    func signOut() {
        authService = AuthService()
        authService?.googleSignOut()
        
        authService?.signOut { [weak self] error in
            if let error {
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            } else {
                self?.authService = nil
            }
        }
    }
}

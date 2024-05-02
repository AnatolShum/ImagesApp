//
//  ValidateManager.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import Foundation

class ValidateManager {
    static let shared = ValidateManager()
    
    func validateEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        guard !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 8 else {
            return false
        }
        
        return true
    }
}

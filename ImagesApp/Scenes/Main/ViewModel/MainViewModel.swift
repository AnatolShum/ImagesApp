//
//  MainViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var userId: String?
    
    private var authService = AuthService()
    
    public var isSignedIn: Bool {
        return authService.currentUser != nil
    }
    
    public var userEmail: String {
        return authService.currentUser?.email ?? "N/A"
    }
    
    public var isEmailVerified: Bool {
        return authService.currentUser?.isEmailVerified ?? false
    }
    
    init() {
        authService.addStateDidChangeListener { [weak self] userId in
            DispatchQueue.main.async {
                self?.userId = userId
            }
        }
    }
    
}

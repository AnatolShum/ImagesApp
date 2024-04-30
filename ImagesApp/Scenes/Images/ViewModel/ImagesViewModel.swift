//
//  ImagesViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation

class ImagesViewModel: ObservableObject {
    private let authService = AuthService()
    
    func signOut() {
        authService.signOut { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

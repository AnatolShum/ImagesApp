//
//  MainViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var userId: String?
    private var handler: AuthStateDidChangeListenerHandle?
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            DispatchQueue.main.async {
                self?.userId = user?.uid
            }
        })
    }
    
}

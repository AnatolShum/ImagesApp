//
//  AuthState.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import Foundation

enum AuthCurrentView {
    case auth
    case verify
}

class AuthState: ObservableObject {
    @Published var currentView: AuthCurrentView = .auth
}

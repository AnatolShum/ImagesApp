//
//  AuthViewState.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import Foundation

enum AuthViewState {
    case signIn
    case singUp
}

extension AuthViewState {
    mutating func toggle() {
        switch self {
        case .signIn:
            self = .singUp
        case .singUp:
            self = .signIn
        }
    }
}

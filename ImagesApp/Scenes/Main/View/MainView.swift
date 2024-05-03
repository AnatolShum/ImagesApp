//
//  MainView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        if let uid = viewModel.userId,
           !uid.isEmpty,
           viewModel.isSignedIn,
           viewModel.isEmailVerified {
            ImagesTabView()
        } else {
            switch authState.currentView {
            case .auth:
                if viewModel.isSignedIn && !viewModel.isEmailVerified {
                    VerifyView(email: viewModel.userEmail)
                } else {
                    AuthView()
                }
            case .verify:
                VerifyView(email: viewModel.userEmail)
            }
        }
    }
}

#Preview {
    MainView()
}

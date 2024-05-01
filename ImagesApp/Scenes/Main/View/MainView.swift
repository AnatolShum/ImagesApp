//
//  MainView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        if let uid = viewModel.userId,
           !uid.isEmpty,
           viewModel.isSignedIn {
            ImagesTabView()
        } else {
            AuthView()
        }
    }
}

#Preview {
    MainView()
}

//
//  ImagesView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

struct ImagesView: View {
    @StateObject private var viewModel = ImagesViewModel()
    
    var body: some View {
        Button("Sign out") {
            viewModel.signOut()
        }
    }
}

#Preview {
    ImagesView()
}

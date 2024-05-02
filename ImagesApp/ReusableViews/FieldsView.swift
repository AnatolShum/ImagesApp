//
//  FieldsView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct FieldsView<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                
                content()
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            
        }
        .background(Color.white.opacity(0.8))
        .clipShape(.rect(cornerRadius: 12))
        .padding(.horizontal, 16)
    }
}

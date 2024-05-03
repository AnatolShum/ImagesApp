//
//  MenuSection.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct MenuSection<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.black
            
            HStack(spacing: 30) {
                content()
            }
            .foregroundStyle(Color.gray)
            .frame(maxWidth: .infinity)
            
        }
        .frame(height: 58)
    }
}

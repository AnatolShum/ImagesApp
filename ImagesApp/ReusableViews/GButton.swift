//
//  GButton.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct GButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                    
                    HStack(spacing: 4) {
                        Image("g_logo")
                            .resizable()
                            .frame(width: 32, height: 32)
                        
                        Text("Continue with Google")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    }
                }
            })
        .foregroundStyle(Color.blue.opacity(0.7))
    }
}

#Preview {
    GButton {}
}

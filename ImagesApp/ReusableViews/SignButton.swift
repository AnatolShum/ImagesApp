//
//  SignButton.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

struct SignButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                    
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Color.white)
                }
            })
        .buttonStyle(DisabledButton(color: color))
    }
}


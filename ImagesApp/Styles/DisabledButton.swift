//
//  DisabledButton.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

struct DisabledButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? color : Color.gray.opacity(0.5))
    }
}

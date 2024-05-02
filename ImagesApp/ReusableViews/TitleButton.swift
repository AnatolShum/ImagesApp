//
//  TitleButton.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct TitleButton: View {
    let title: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
               action()
            }, label: {
                Text(title)
                    .font(.headline)
            })
            .foregroundStyle(Color.red.opacity(0.7))
            
            Spacer()
        }
    }
}

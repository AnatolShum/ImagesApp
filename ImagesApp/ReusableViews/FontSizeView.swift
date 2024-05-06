//
//  FontSizeView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 06.05.2024.
//

import SwiftUI

struct FontSizeView: View {
    let fontSize: String
    let upAction: () -> ()
    let downAction: () -> ()
    
    var body: some View {
        VStack(spacing: 5) {
            Button(action: {
                upAction()
            }, label: {
                Image(systemName: "arrowtriangle.up.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 8, height: 8)
            })
            
            Text(fontSize)
                .font(.headline)
            
            Button(action: {
                downAction()
            }, label: {
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 8, height: 8)
            })
        }
    }
}

//
//  TabItem.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import SwiftUI

struct TabItem: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
            
            Text(title)
                .font(.subheadline)
        }
    }
}

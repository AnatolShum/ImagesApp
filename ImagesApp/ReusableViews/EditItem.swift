//
//  EditItem.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import SwiftUI

struct EditItem: View {
    let title: String
    let imageName: String
   
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 22, height: 22)
            
            Text(title)
                .font(.system(size: 12))
        }
    }
}

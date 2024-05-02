//
//  TitleView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct TitleView: View {
    let title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
            .foregroundStyle(Color.white)
    }
}

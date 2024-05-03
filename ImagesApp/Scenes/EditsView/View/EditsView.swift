//
//  EditsView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import SwiftUI

struct EditsView: View {
    @StateObject private var viewModel = EditsViewModel()
    
    var body: some View {
        Text("Page for edited photos")
    }
}

#Preview {
    EditsView()
}

//
//  TextBox.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 05.05.2024.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable {
    let id: String = UUID().uuidString
    var text: String
    var isBold: Bool = false
    var fontSize: CGFloat = 24.0
    var textColor: Color = .white
    var offset: CGSize = .zero
    var previousOffset: CGSize = .zero
}

//
//  DetailImageViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import Foundation
import SwiftUI
import PencilKit

class DetailImageViewModel: ObservableObject {
    @Published var rotationDegrees: Double = 0
    @Published var canvasView = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var isPickerShowing: Bool = false
    
    func rotateRight() {
        if rotationDegrees == 360 {
            rotationDegrees = 0
        }
        rotationDegrees += 90
    }
    
    func rotateLeft() {
        if rotationDegrees == -360 {
            rotationDegrees = 0
        }
        rotationDegrees -= 90
    }
    
    @MainActor func saveImage(_ image: Image) {
        let render = ImageRenderer(content: image)
        guard let uiImage = render.uiImage else { return }
        
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
}

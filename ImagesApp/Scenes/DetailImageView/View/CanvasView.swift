//
//  CanvasView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 03.05.2024.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var image: UIImage?
    @Binding var toolPicker: PKToolPicker
    @Binding var isPickerShowing: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        
        if isPickerShowing {
            canvasView.drawingPolicy = .anyInput
        }
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        guard let subView = canvasView.subviews.first else { return }
        subView.addSubview(imageView)
        subView.sendSubviewToBack(imageView)
        
        if isPickerShowing {
            showToolPicker()
        } else {
            hideToolPicker()
        }
    }
    
    private func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    
    private func hideToolPicker() {
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        toolPicker.removeObserver(canvasView)
    }
}

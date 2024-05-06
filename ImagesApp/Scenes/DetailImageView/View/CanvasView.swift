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
    
    var size: CGSize
    let imageView = UIImageView()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        
        if isPickerShowing {
            canvasView.drawingPolicy = .anyInput
        }
        
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        if let subView = canvasView.subviews.first {
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
        }
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
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

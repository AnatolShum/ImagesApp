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
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.backgroundColor = .clear
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {}
}

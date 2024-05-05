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
    @Published var textBoxes: [TextBox] = []
    @Published var isWriting: Bool = false
    @Published var currentIndex: Int = 0
    @Published var rect: CGRect = .zero
    @Published var showAlert: Bool = false
    
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
    
    @MainActor func saveImage() {
        renderImage { [weak self] image in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self?.showAlert = true
        }
    }
    
    private func renderImage(completion: @escaping (UIImage) -> Void) {
        UIGraphicsImageRenderer(size: rect.size).image { context in
            canvasView.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
            let view = ZStack {
                ForEach(textBoxes) { [self] textBox in
                    Text(self.getText(textBox))
                        .font(.system(size: textBox.fontSize))
                        .fontWeight(textBox.isBold ? .bold : .regular)
                        .foregroundStyle(textBox.textColor)
                        .offset(textBox.offset)
                }
            }
            
            guard let controller = UIHostingController(rootView: view).view else { return }
            controller.backgroundColor = .clear
            controller.frame = rect
            controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
            
            let image = context.currentImage
            
            completion(image)
        }
    }
    
    func addTextBox() {
        isWriting.toggle()
        textBoxes.append(TextBox(text: ""))
        currentIndex = textBoxes.count - 1
    }
    
    func cancelTexting() {
        withAnimation {
            isWriting = false
        }
        textBoxes.removeLast()
    }
    
    func getText(_ textBox: TextBox) -> String {
        guard !textBoxes.isEmpty && currentIndex == textBoxes.count - 1 else { return "" }
        if textBoxes[currentIndex].id == textBox.id && isWriting {
            return ""
        } else {
            return textBox.text
        }
    }
    
    func getIndex(_ textBox: TextBox) -> Int {
        let index = textBoxes.firstIndex { $0.id == textBox.id }
        return index ?? 0
    }
}

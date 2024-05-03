//
//  DetailImageViewModel.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import Foundation


class DetailImageViewModel: ObservableObject {
    @Published var rotationDegrees: Double = 0
    
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
}

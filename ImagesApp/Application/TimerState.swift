//
//  TimerState.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import Foundation

class TimerState: ObservableObject {
    @Published var counter: Int = 60
    @Published var isRunning: Bool = false
    
    private var timer = Timer()
    
    final func runTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateButton),
            userInfo: nil,
            repeats: true)
    }
    
    @objc
    private func updateButton() {
        if counter > 0 {
            counter -= 1
        } else {
            timer.invalidate()
            isRunning = false
            counter = 60
        }
    }
}

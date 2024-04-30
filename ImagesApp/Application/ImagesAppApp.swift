//
//  ImagesAppApp.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

@main
struct ImagesAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

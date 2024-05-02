//
//  ImagesAppApp.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI
import GoogleSignIn

@main
struct ImagesAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private var authState = AuthState()
    private var timerState = TimerState()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onOpenURL { url in
                                GIDSignIn.sharedInstance.handle(url)
                            }
                .environmentObject(authState)
                .environmentObject(timerState)
        }
    }
}

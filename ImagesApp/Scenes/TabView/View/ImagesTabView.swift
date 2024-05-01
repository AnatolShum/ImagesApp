//
//  ImagesTabView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import SwiftUI

struct ImagesTabView: View {
    var body: some View {
        TabView {
            DeviceImagesView()
                .tabItem {
                    TabItem(imageName: "photo.stack", title: "Device")
                }
            
            EditsView()
                .tabItem {
                    TabItem(imageName: "photo.badge.checkmark", title: "Edits")
                }
            
            SettingsView()
                .tabItem {
                    TabItem(imageName: "gear", title: "Settings")
                }
        }
        .tint(.black)
    }
}

#Preview {
    ImagesTabView()
}

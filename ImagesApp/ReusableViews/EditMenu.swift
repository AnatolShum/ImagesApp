//
//  EditMenu.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import SwiftUI

struct EditMenu: View {
    
    enum MenuItems: CaseIterable {
        case crop
        case filters
        case text
        case markup
        
        var title: String {
            switch self {
            case .crop:
                return "Crop"
            case .filters:
                return "Filters"
            case .text:
                return "Text"
            case .markup:
                return "Markup"
            }
        }
        
        var imageName: String {
            switch self {
            case .crop:
                return "crop.rotate"
            case .filters:
                return "camera.filters"
            case .text:
                return "textbox"
            case .markup:
                return "pencil.tip.crop.circle"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black
            
            HStack(spacing: 30) {
                
                ForEach(MenuItems.allCases, id: \.self) { item in
                    EditItem(title: item.title, imageName: item.imageName)
                        .foregroundStyle(Color.white.opacity(0.8))
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                print("Tapped \(item)")
                            }
                        }
                }
                
            }
            
        }
        .frame(height: 58)
    }
}

#Preview {
    EditMenu()
}

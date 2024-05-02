//
//  DeviceImagesView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import PhotosUI
import SwiftUI

struct DeviceImagesView: View {
    @StateObject private var viewModel = DeviceImagesViewModel()
    
    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    
    private let columns = [GridItem(.flexible(minimum: 80), spacing: 10), GridItem(.flexible(minimum: 80), spacing: 10)]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            NavigationLink {
                                DetailImageView(image: selectedImages[index])
                            } label: {
                                selectedImages[index]
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 10)
                .scrollIndicators(.hidden)
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    PhotosPicker(selection: $pickerItems, matching: .images) {
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
        .onChange(of: pickerItems) {
            Task {
                selectedImages.removeAll()
                
                for item in pickerItems {
                    if let loadedImage = try await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
            }
        }
    }
}

#Preview {
    DeviceImagesView()
}

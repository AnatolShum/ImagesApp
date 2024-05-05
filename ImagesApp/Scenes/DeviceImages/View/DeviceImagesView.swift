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
            ZStack {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                let render = ImageRenderer(content: selectedImages[index])
                                let uiImage = render.uiImage
                                NavigationLink {
                                    DetailImageView(image: selectedImages[index], uiImage: uiImage)
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
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.blue)
                                .frame(width: 44, height: 44)
                                .shadow(color: .gray, radius: 4)
                            
                            PhotosPicker(selection: $pickerItems, matching: .images) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 28, height: 28)
                            }
                        }
                    }
                    .padding(.trailing, 30)
                }
                .padding(.bottom, 30)
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

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
    @State private var selectedImages: [UIImage] = []
    
    private let columns = [GridItem(.flexible(minimum: 80), spacing: 10), GridItem(.flexible(minimum: 80), spacing: 10)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !selectedImages.isEmpty {
                    VStack {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(0..<selectedImages.count, id: \.self) { index in
                                    NavigationLink {
                                        DetailImageView(uiImage: selectedImages[index])
                                    } label: {
                                        Image(uiImage: selectedImages[index])
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
                } else {
                    ContentUnavailableView(
                        "No pictures",
                        systemImage: "photo.on.rectangle",
                        description: Text("Please click the button below to select photos"))
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
                    if let imageData = try await item.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: imageData) {
                            withAnimation(.smooth(duration: 0.75)) {
                                selectedImages.append(uiImage)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DeviceImagesView()
}

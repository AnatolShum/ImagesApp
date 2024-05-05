//
//  DetailImageView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI
import PencilKit

struct DetailImageView: View {
    let context = CIContext()
    
    @StateObject private var viewModel = DetailImageViewModel()
    
    @Environment(\.undoManager) private var undoManager
    
    @GestureState private var zoom = 1.0
    
    @State var image: Image
    @State var uiImage: UIImage?
    @State private var editedImage: Image
    @State private var selectedItem: MenuItems = .none
    @State private var filterIntensity = 0.5
    @State private var sepiaFilter = CIFilter.sepiaTone()
    @State private var bloomFilter = CIFilter.bloom()
    
    init(image: Image, uiImage: UIImage?) {
        self.image = image
        self.uiImage = uiImage
        self.editedImage = image
    }
    
    enum MenuItems: CaseIterable {
        case crop
        case filters
        case text
        case markup
        case none
        
        var title: String? {
            switch self {
            case .crop:
                return "Crop"
            case .filters:
                return "Filters"
            case .text:
                return "Text"
            case .markup:
                return "Markup"
            case .none:
                return nil
            }
        }
        
        var imageName: String? {
            switch self {
            case .crop:
                return "crop.rotate"
            case .filters:
                return "camera.filters"
            case .text:
                return "textbox"
            case .markup:
                return "pencil.tip.crop.circle"
            case .none:
                return nil
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
            
            VStack {
                GeometryReader { reader -> AnyView in
                    let size = reader.frame(in: .global).size
                    
                    DispatchQueue.main.async {
                        viewModel.rect = reader.frame(in: .global)
                    }
                    
                    return AnyView(
                        ZStack {
                            CanvasView(canvasView: $viewModel.canvasView,
                                       image: $uiImage,
                                       toolPicker: $viewModel.toolPicker,
                                       isPickerShowing: $viewModel.isPickerShowing, size: size)
                            .scaleEffect(zoom)
                            .gesture(
                                MagnifyGesture()
                                    .updating($zoom) { value, state, transaction in
                                        state = value.magnification
                                    })
                            
                            ForEach(viewModel.textBoxes) { textBox in
                                Text(viewModel.getText(textBox))
                                    .font(.system(size: textBox.fontSize))
                                    .fontWeight(textBox.isBold ? .bold : .regular)
                                    .foregroundStyle(textBox.textColor)
                                    .offset(textBox.offset)
                                    .gesture(DragGesture().onChanged({ value in
                                        let currentOffset = value.translation
                                        let previousOffset = textBox.previousOffset
                                        let newOffset = CGSize(
                                            width: previousOffset.width + currentOffset.width,
                                            height: previousOffset.height + currentOffset.height)
                                        
                                        viewModel.textBoxes[viewModel.getIndex(textBox)].offset = newOffset
                                    }).onEnded({ value in
                                        viewModel.textBoxes[viewModel.getIndex(textBox)].previousOffset = value.translation
                                    }))
                            }
                        }
                    )
                }
                
                Spacer()
                
                VStack(spacing: 1) {
                    switch selectedItem {
                    case .crop:
                        MenuSection {
                            MenuItem(title: "Rotate", imageName: "rotate.left")
                                .onTapGesture {
                                    viewModel.rotateLeft()
                                }
                            
                            MenuItem(title: "Rotate", imageName: "rotate.right")
                                .onTapGesture {
                                    viewModel.rotateRight()
                                }
                        }
                    case .filters:
                        MenuSection {
                            MenuItem(title: "Sepia", imageName: "photo")
                                .onTapGesture {
                                    sepiaFilter.setValue(renderImage(), forKey: kCIInputImageKey)
                                    applySepia()
                                }
                            
                            MenuItem(title: "Bloom", imageName: "photo")
                                .onTapGesture {
                                    bloomFilter.setValue(renderImage(), forKey: kCIInputImageKey)
                                    applyBloom()
                                }
                        }
                    case .text:
                        ZStack {}
                    case .markup:
                        MenuSection {
                            MenuItem(title: "Undo", imageName: "arrow.uturn.backward.circle")
                                .onTapGesture {
                                    undoManager?.undo()
                                }
                            
                            MenuItem(title: "Redo", imageName: "arrow.uturn.forward.circle")
                                .onTapGesture {
                                    undoManager?.redo()
                                }
                        }
                    case .none:
                        ZStack {}
                    }
                    
                    ZStack {
                        Color.black
                        
                        HStack {
                            Spacer()
                            HStack(spacing: 30) {
                                ForEach(MenuItems.allCases, id: \.self) { item in
                                    if item != .none {
                                        MenuItem(title: item.title ?? "",
                                                 imageName: item.imageName ?? "")
                                        .foregroundStyle(
                                            selectedItem == item ? Color.white : Color.gray)
                                        .onTapGesture {
                                            withAnimation(.easeInOut) {
                                                selectedItem = item
                                                
                                                if item == .markup {
                                                    viewModel.isPickerShowing = true
                                                } else if item == .text {
                                                    viewModel.addTextBox()
                                                } else if item != .markup {
                                                    viewModel.isPickerShowing = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.leading, 40)
                            
                            Spacer()
                            
                            HStack {
                                if selectedItem != .none {
                                    Image(systemName: "xmark.square")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.gray)
                                        .frame(width: 22, height: 22)
                                        .onTapGesture {
                                            withAnimation(.easeInOut) {
                                                selectedItem = .none
                                                viewModel.isPickerShowing = false
                                            }
                                        }
                                }
                                
                                Spacer()
                            }
                            .frame(width: 40)
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    .frame(height: 58)
                }
                .padding(.bottom, viewModel.isPickerShowing ? 80 : 0)
                .frame(height: 113, alignment: .bottom)
            }
            .toolbar(.hidden, for: .tabBar)
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            if viewModel.isWriting {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                TextField("Enter your text", text: $viewModel.textBoxes[viewModel.currentIndex].text)
                    .font(.title)
                    .preferredColorScheme(.dark)
                    .foregroundStyle(viewModel.textBoxes[viewModel.currentIndex].textColor)
                    .padding()
                
                HStack {
                    Button(action: {
                        viewModel.cancelTexting()
                        selectedItem = .none
                    }, label: {
                        Text("Cancel")
                            .font(.title2)
                            .bold()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            viewModel.isWriting = false
                            selectedItem = .none
                        }
                    }, label: {
                        Text("Add")
                            .font(.title2)
                            .bold()
                    })
                }
                .overlay {
                    ColorPicker("", selection: $viewModel.textBoxes[viewModel.currentIndex].textColor)
                        .labelsHidden()
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 26)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                TBItem(systemName: "arrow.uturn.backward") {
                    returnOriginalImage()
                }
                
                TBItem(systemName: "square.and.arrow.down") {
                    viewModel.saveImage()
                }
                
                ShareLink(item: editedImage, preview: SharePreview("Edited image", image: editedImage)) {
                    Image(systemName: "square.and.arrow.up")
                        .renderingMode(.template)
                        .foregroundStyle(Color.black)
                }
            }
        }
        .alert("",
               isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                viewModel.showAlert = false
            }
        } message: {
            Text("Photo successfully saved in the Library")
        }
    }
    
    private func renderImage() -> CIImage? {
        let render = ImageRenderer(content: editedImage)
        guard let uiImage = render.uiImage else { return nil }
        return CIImage(image: uiImage)
    }
    
    private func applySepia() {
        sepiaFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = sepiaFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        self.uiImage = uiImage
        editedImage = Image(uiImage: uiImage)
    }
    
    private func applyBloom() {
        bloomFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = bloomFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        self.uiImage = uiImage
        editedImage = Image(uiImage: uiImage)
    }
    
    private func returnOriginalImage() {
        editedImage = image
    }
}

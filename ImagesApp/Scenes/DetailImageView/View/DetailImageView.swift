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
    
    @State var uiImage: UIImage
    @State private var image: Image
    @State private var editedImage: Image
    @State private var selectedItem: MenuItems = .none
    @State private var filterIntensity = 0.5
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
        self.image = Image(uiImage: uiImage)
        self.editedImage = Image(uiImage: uiImage)
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
                GeometryReader { reader in
                    ZStack {
                        CanvasView(canvasView: $viewModel.canvasView,
                                   image: $uiImage,
                                   toolPicker: $viewModel.toolPicker,
                                   isPickerShowing: $viewModel.isPickerShowing, size: reader.frame(in: .global).size)
                        .scaleEffect(zoom)
                        .rotationEffect(.degrees(viewModel.rotationDegrees))
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
                    .padding(.bottom, 80)
                    .onAppear {
                        DispatchQueue.main.async {
                            viewModel.rect = reader.frame(in: .global)
                        }
                    }
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
                                    setFilter(CIFilter.sepiaTone())
                                }
                            
                            MenuItem(title: "Bloom", imageName: "photo")
                                .onTapGesture {
                                    setFilter(CIFilter.bloom())
                                }
                            
                            MenuItem(title: "Blur", imageName: "photo")
                                .onTapGesture {
                                    setFilter(CIFilter.gaussianBlur())
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
                                                    viewModel.isPickerShowing = false
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
                    .font(.system(
                        size: viewModel.textBoxes[viewModel.currentIndex].fontSize,
                        weight: viewModel.textBoxes[viewModel.currentIndex].isBold ? .bold : .regular))
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
                    HStack(spacing: 30) {
                        ColorPicker("", selection: $viewModel.textBoxes[viewModel.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button(action: {
                            viewModel.textBoxes[viewModel.currentIndex].isBold.toggle()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(viewModel.textBoxes[viewModel.currentIndex].isBold ? Color.gray.opacity(0.75) : .clear)
                                
                                Image(systemName: "bold")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 18, height: 18)
                                    .padding(.all, 4)
                            }
                            .frame(width: 26, height: 26)
                        })
                        
                        FontSizeView(
                            fontSize: "\(Int(viewModel.textBoxes[viewModel.currentIndex].fontSize))",
                            upAction: {
                                let newSize = viewModel.plusFontSize(viewModel.textBoxes[viewModel.currentIndex].fontSize)
                                viewModel.textBoxes[viewModel.currentIndex].fontSize = newSize
                            },  downAction: {
                                let newSize = viewModel.minusFontSize(viewModel.textBoxes[viewModel.currentIndex].fontSize)
                                viewModel.textBoxes[viewModel.currentIndex].fontSize = newSize
                            })
                    }
                    .padding(.top, 70)
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 26)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                TBItem(systemName: "arrow.uturn.backward") {
                    viewModel.textBoxes = []
                    undoManager?.undo()
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
        return CIImage(image: uiImage)
    }
    
    private func applyFilter() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        self.uiImage = uiImage
        editedImage = Image(uiImage: uiImage)
    }
    
    private func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        currentFilter.setValue(renderImage(), forKey: kCIInputImageKey)
        applyFilter()
    }
    
    private func returnOriginalImage() {
        editedImage = image
    }
}

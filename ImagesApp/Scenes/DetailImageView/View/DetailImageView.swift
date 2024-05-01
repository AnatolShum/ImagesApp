//
//  DetailImageView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 01.05.2024.
//

import SwiftUI

struct DetailImageView: View {
    let image: Image
    
    @StateObject private var viewModel = DetailImageViewModel()
    @GestureState private var zoom = 1.5
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(zoom)
                    .gesture(
                    MagnifyGesture()
                        .updating($zoom) { value, state, transaction in
                            state = value.magnification
                        })
                
                Spacer()
                
                VStack(spacing: 1) {
                    
//                    ZStack {
//                        Color.black
//                        
//                        HStack(spacing: 16) {
//                         
//                        EditItem(title: "Gear", imageName: "gear")
//                                .foregroundStyle(Color.white.opacity(0.8))
//                                .onTapGesture {
//                                    withAnimation(.easeInOut) {
//                                        print("Tapped")
//                                    }
//                                }
//                   
//                        }
//
//                    }
//                    .frame(height: 58)
                }
               
                

            }
            .toolbar(.hidden, for: .tabBar)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    DetailImageView(image: Image("IMG_0831"))
}

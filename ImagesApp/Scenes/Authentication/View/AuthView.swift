//
//  AuthView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var viewState = AuthViewState.signIn
    @State private var gradientColors: [Color] = [.green, .mint, .cyan]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    Text(viewModel.viewTitle(viewState))
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                    
                    ZStack {
                        VStack(spacing: 16) {
                            HStack {
                                TextField("",
                                          text: $viewModel.email,
                                          prompt:
                                            Text("Email address")
                                    .foregroundStyle(Color.black)
                                )
                                .frame(height: 40)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                                .padding(.horizontal, 8)
                            }
                            .background(Color.gray)
                            .clipShape(.rect(cornerRadius: 8))
                            
                            HStack {
                                SecureField("",
                                            text: $viewModel.password,
                                            prompt:
                                                Text("Password")
                                    .foregroundStyle(Color.black)
                                )
                                .frame(height: 40)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.horizontal, 8)
                            }
                            .background(Color.gray)
                            .clipShape(.rect(cornerRadius: 8))
                            
                            SignButton(title: viewModel.viewTitle(viewState),
                                       color: .blue) {
                                viewModel.signButtonAction(viewState)
                            }
                                       .frame(height: 40)
                                       .disabled(viewModel.isButtonDisable)
                            
                            HStack {
                                Button(action: {
                                    viewState.toggle()
                                    gradientColors.reverse()
                                    viewModel.email = ""
                                    viewModel.password = ""
                                }, label: {
                                    Text(viewModel.chooseStateTitle(viewState))
                                        .font(.headline)
                                })
                                .foregroundStyle(Color.red.opacity(0.7))
                                
                                Spacer()
                            }
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                        
                    }
                    .background(Color.white.opacity(0.8))
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
        }
        .alert("Authentication error",
               isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                viewModel.showAlert = false
                viewModel.errorMessage = ""
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    AuthView()
}

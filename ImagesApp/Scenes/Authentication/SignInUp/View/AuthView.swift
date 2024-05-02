//
//  AuthView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 30.04.2024.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    @EnvironmentObject var authState: AuthState
    
    @State private var viewState = AuthViewState.signIn
    @State private var gradientColors: [Color] = [.green, .mint, .cyan]
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView(colors: $gradientColors)
                
                VStack {
                    TitleView(title: viewModel.viewTitle(viewState))
                    
                    Spacer()
                    
                    FieldsView {
                        EmailTextField(email: $viewModel.email)
                        
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
                            
                            if let isVerified = viewModel.isVerified, !isVerified {
                                authState.currentView = .verify
                            }
                        }
                                   .frame(height: 40)
                                   .disabled(viewModel.isButtonDisable)
                        
                        GButton {
                            viewModel.signInGoogle()
                        }
                        .frame(height: 40)
                        
                        TitleButton(title: viewModel.chooseStateTitle(viewState)) {
                            viewState.toggle()
                            gradientColors.reverse()
                            viewModel.email = ""
                            viewModel.password = ""
                        }
                        
                        NavigationLink {
                            ForgotPassView()
                        } label: {
                            HStack {
                                Text("forgotPass")
                                    .font(.headline)
                                    .foregroundStyle(Color.red.opacity(0.7))
                                
                                Spacer()
                            }
                        }
                    }
                    
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

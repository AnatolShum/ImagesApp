//
//  ForgotPassView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct ForgotPassView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = ForgotPassViewModel()
    
    @State private var gradientColors: [Color] = [.orange, .orange.opacity(0.8), .yellow, .yellow.opacity(0.7)]
    @State private var showInfoAlert: Bool = false
    @State private var showProgressView: Bool = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView(colors: $gradientColors)
            
            VStack {
                TitleView(title: "sendPasswordReset")
                
                Spacer()
                
                if showProgressView {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color.white)
                } else {
                    FieldsView {
                        EmailTextField(email: $viewModel.email)
                        
                        SignButton(title: "send",
                                   color: .pink) {
                            showProgressView = true
                            
                            viewModel.sendPasswordReset {
                                showInfoAlert = true
                            }
                        }
                        .frame(height: 40)
                        .disabled(viewModel.isButtonDisable)
                    }
                }
                
                Spacer()
            }
        }
        .alert("",
               isPresented: $showInfoAlert,
               actions: {
            Button("Ok", role: .cancel) {
                showInfoAlert = false
                showProgressView = false
                dismiss()
            }
        },
               message: {
            Text("Please follow the email instructions and login again.")
        })
        .alert("Authentication error",
               isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                viewModel.showAlert = false
                viewModel.errorMessage = ""
                showProgressView = false
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    ForgotPassView()
}

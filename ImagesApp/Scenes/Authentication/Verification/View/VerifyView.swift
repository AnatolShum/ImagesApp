//
//  VerifyView.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct VerifyView: View {
    let email: String
    
    @StateObject private var viewModel = VerifyViewModel()
    
    @EnvironmentObject var timerState: TimerState
    @EnvironmentObject var authState: AuthState
    
    @State private var gradientColors: [Color] = [.indigo, .blue, .cyan]
    
    var body: some View {
        ZStack {
            GradientBackgroundView(colors: $gradientColors)
            
            VStack {
                TitleView(title: "verifyEmail")
                
                Spacer()
                
                FieldsView {
                    Text("A verification email has been sent to \(email)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.black.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(
                        action: {
                            viewModel.sendEmailVerification()
                        },
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                
                                Text(viewModel.buttonTitle)
                                    .font(.headline)
                                    .foregroundStyle(Color.white)
                            }
                        })
                    .buttonStyle(DisabledButton(color: .purple))
                    .frame(height: 40)
                    .disabled(viewModel.isButtonDisable)
                    
                    TitleButton(title: "login") {
                        viewModel.signOut()
                        authState.currentView = .auth
                    }
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .renderingMode(.template)
                            
                            Text("Sign in")
                                .font(.headline)
                        }
                        .foregroundStyle(Color.white)
                    })
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
        .onAppear {
            timerState.isRunning = true
            timerState.runTimer()
        }
        .onChange(of: timerState.counter) { _, newValue in
            if timerState.isRunning {
                viewModel.updateButtonParams(newValue)
            }
        }
    }
}

#Preview {
    VerifyView(email: "test@test.test")
}

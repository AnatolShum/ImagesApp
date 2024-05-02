//
//  EmailTextField.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 02.05.2024.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    
    var body: some View {
        HStack {
            TextField("",
                      text: $email,
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
    }
}

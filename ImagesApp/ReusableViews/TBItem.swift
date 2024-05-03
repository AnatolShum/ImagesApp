//
//  TBItem.swift
//  ImagesApp
//
//  Created by Anatolii Shumov on 03.05.2024.
//

import SwiftUI

struct TBItem: View {
    let systemName: String
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: systemName)
                .foregroundStyle(Color.black)
        })
    }
}


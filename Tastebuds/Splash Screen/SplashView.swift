//
//  SplashView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Tastebuds")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Find recipes your tastebuds will love.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.adaptiveAccent)
    }
}

#Preview {
    SplashView()
        .padding()
}

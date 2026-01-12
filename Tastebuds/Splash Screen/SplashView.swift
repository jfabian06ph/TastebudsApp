//
//  SplashView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("brandLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipped()
                .padding(.horizontal, 16)
            Text("Find recipes your tastebuds will love.")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, -20)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding(.top, 16)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.adaptiveAccent)
    }
}

#Preview {
    SplashView()
        .padding()
}

//
//  AppLaunchView.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI

struct AppLaunchView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            // Main content
            NavigationStack {
                RecipeListView()
            }.opacity(showSplash ? 0 : 1)

            // Splash overlay
            if showSplash {
                SplashView()
                    .transition(.opacity)
            }
        }.onAppear {
            // Hide splash after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

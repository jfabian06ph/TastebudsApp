//
//  TastebudsApp.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI

@main
struct TastebudsApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            AppLaunchView()
        }
    }
}

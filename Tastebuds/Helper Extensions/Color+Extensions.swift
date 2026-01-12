//
//  Color+Extensions.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI

extension Color {
    static let darkOrange = Color(UIColor(red: 255/255, green: 85/255, blue: 0/255, alpha: 1)) // HEX: #080820
    
    static let adaptiveAccent = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 8/255, green: 8/255, blue: 32/255, alpha: 1) // HEX: #080820
            : .white
    })
    
    static let primaryBrandColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 255/255, green: 85/255, blue: 0/255, alpha: 1)
            : .white
    })
    
    static let secondaryBrandColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 255/255, green: 185/255, blue: 150/255, alpha: 1) // HEX: #FFB996
            : UIColor(red: 255/255, green: 85/255, blue: 0/255, alpha: 1) // HEX: #FF5500
    })
}

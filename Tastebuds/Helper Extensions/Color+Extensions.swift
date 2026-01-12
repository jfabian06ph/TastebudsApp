//
//  Color+Extensions.swift
//  Tastebuds
//
//  Created by Joseph Z. Fabian on 1/12/26.
//

import SwiftUI

extension Color {
    static let darkOrange = Color(UIColor(red: 255/255, green: 85/255, blue: 0/255, alpha: 1)) // HEX: #080820
    static let lightOrange = Color(UIColor(red: 255/255, green: 185/255, blue: 150/255, alpha: 1)) // HEX: #080820
    
    static let adaptiveAccent = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 8/255, green: 8/255, blue: 32/255, alpha: 1) // HEX: #080820
            : .white
    })
    
    static let cardBackgroundColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 52/255, green: 53/255, blue: 76/255, alpha: 1) // HEX: #34354C
            : UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1) // HEX: #f9f9fb
    })
    
    static let primaryBrandColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 255/255, green: 185/255, blue: 150/255, alpha: 1) // HEX: #FFB996
            : UIColor(red: 255/255, green: 85/255, blue: 0/255, alpha: 1) // HEX: #FF5500
    })
    
    static let filterChipUnselectedStateColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 186/255, green: 186/255, blue: 185/255, alpha: 1) // HEX: #6F6763
            : UIColor(red: 111/255, green: 103/255, blue: 99/255, alpha: 1) // HEX: #BABAB9
    })
}

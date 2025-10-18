//
//  ColorConstants.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import SwiftUI

struct ColorConstants {
    // MARK: - Primary Colors (Coffee Theme)
    static let primary = Color(red: 0.8, green: 0.6, blue: 0.4)      // Café claro
    static let primaryDark = Color(red: 0.4, green: 0.3, blue: 0.2)  // Café oscuro
    
    // MARK: - Background Colors
    static let backgroundDark = Color(red: 0.2, green: 0.15, blue: 0.1)
    static let backgroundDarker = Color(red: 0.15, green: 0.1, blue: 0.05)
    static let surfaceLight = Color.white.opacity(0.08)
    
    // MARK: - Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.5)
    
    // MARK: - Status Colors
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)       // Verde
    static let error = Color(red: 1, green: 0.3, blue: 0.3)           // Rojo
    static let warning = Color(red: 1, green: 0.8, blue: 0.2)         // Amarillo
    static let info = Color(red: 0.3, green: 0.7, blue: 1)            // Azul
    
    // MARK: - Border Colors
    static let borderLight = Color.white.opacity(0.2)
    static let borderMedium = Color.white.opacity(0.3)
    
    // MARK: - Gradient Background
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            backgroundDark,
            backgroundDarker
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

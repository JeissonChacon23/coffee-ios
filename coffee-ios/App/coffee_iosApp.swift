//
//  coffee_iosApp.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import SwiftUI
import FirebaseCore

@main
struct coffee_iosApp: App {
    init() {
        // Configurar Firebase
        FirebaseApp.configure()
        
        // Configurar logging
        Logger.shared.setupLogging()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

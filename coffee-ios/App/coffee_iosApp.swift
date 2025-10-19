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
    @StateObject private var authViewModel = AuthViewModelFactory.makeAuthViewModel()
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Setup logging
        Logger.shared.setupLogging()
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                // Main app content (to be implemented)
                VStack {
                    Text("Welcome, \(authViewModel.currentUser?.fullName ?? "User")")
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Sign Out")
                    }
                }
            } else {
                // Auth views
                ZStack {
                    ColorConstants.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Login View")
                            .foregroundColor(ColorConstants.textPrimary)
                    }
                }
            }
        }
    }
}

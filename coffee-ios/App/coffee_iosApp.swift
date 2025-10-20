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
                // Main app content (authenticated user)
                MainAppView(viewModel: authViewModel)
            } else {
                // Auth views (unauthenticated user)
                LoginView(viewModel: authViewModel)
            }
        }
    }
}

// MARK: - MainAppView
struct MainAppView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            // Towns
            TownsListView(
                viewModel: TownsViewModelFactory.makeTownsListViewModel()
            )
            .tabItem {
                Label("Towns", systemImage: "map.fill")
            }
            
            // Search
            ZStack {
                ColorConstants.backgroundGradient
                    .ignoresSafeArea()
                Text("Search (Coming Soon)")
                    .foregroundColor(ColorConstants.textPrimary)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            // Favorites
            ZStack {
                ColorConstants.backgroundGradient
                    .ignoresSafeArea()
                Text("Favorites (Coming Soon)")
                    .foregroundColor(ColorConstants.textPrimary)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            
            // Profile
            ZStack {
                ColorConstants.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Profile")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(ColorConstants.textPrimary)
                    
                    if let user = viewModel.currentUser {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Name: \(user.fullName)")
                                .foregroundColor(ColorConstants.textSecondary)
                            Text("Email: \(user.email)")
                                .foregroundColor(ColorConstants.textSecondary)
                            Text("Type: \(user.type.rawValue)")
                                .foregroundColor(ColorConstants.textSecondary)
                        }
                        .padding(20)
                        .background(ColorConstants.surfaceLight)
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(ColorConstants.error)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(20)
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(ColorConstants.primary)
    }
}

//
//  AppConstants.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

enum AppConstants {
    // MARK: - App Info
    static let appName = "Town's Coffee"
    static let appVersion = "1.0.0"
    static let appBundleID = "com.townscoffee.ios"
    
    // MARK: - Firebase Collections
    enum FirebaseCollections {
        static let users = "users"
        static let towns = "towns"
        static let caficultores = "caficultores"
        static let coffees = "coffees"
        static let orders = "orders"
    }
    
    // MARK: - User Types
    enum UserTypes {
        static let cliente = "cliente"
        static let caficultor = "caficultor"
        static let admin = "admin"
    }
    
    // MARK: - Validation
    enum Validation {
        static let minPasswordLength = 6
        static let emailRegex = "^\\S+@\\S+\\.\\S+$"
        static let phoneRegex = "^\\d{10}$"
        static let cedulaRegex = "^\\d{1,10}$"
    }
    
    // MARK: - Timing
    enum Timing {
        static let errorMessageDuration: TimeInterval = 5
        static let successMessageDuration: TimeInterval = 2
        static let loadingTimeout: TimeInterval = 30
    }
    
    // MARK: - URLs
    enum URLs {
        static let privacyPolicy = "https://townscoffee.com/privacy"
        static let termsOfService = "https://townscoffee.com/terms"
        static let supportEmail = "support@townscoffee.com"
    }
}

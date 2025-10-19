//
//  AnalyticsManager.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import FirebaseAnalytics

// MARK: - AnalyticsManager
class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    // MARK: - Auth Events
    
    func logSignUp(email: String, userType: String) {
        Analytics.logEvent("sign_up", parameters: [
            AnalyticsParameterMethod: "email",
            "user_type": userType,
            "email_domain": extractDomain(from: email)
        ])
        Logger.shared.info("📊 Analytics: Sign up event logged")
    }
    
    func logSignIn(email: String, success: Bool) {
        Analytics.logEvent("login", parameters: [
            AnalyticsParameterMethod: "email",
            "success": success,
            "email_domain": extractDomain(from: email)
        ])
        Logger.shared.info("📊 Analytics: Sign in event logged")
    }
    
    func logSignOut() {
        Analytics.logEvent("logout", parameters: nil)
        Logger.shared.info("📊 Analytics: Sign out event logged")
    }
    
    func logPasswordReset(email: String, success: Bool) {
        Analytics.logEvent("password_reset", parameters: [
            "success": success,
            "email_domain": extractDomain(from: email)
        ])
        Logger.shared.info("📊 Analytics: Password reset event logged")
    }
    
    // MARK: - App Events
    
    func logScreenView(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ])
        Logger.shared.info("📊 Analytics: Screen view - \(screenName)")
    }
    
    func logTownView(townName: String, townID: String) {
        Analytics.logEvent("town_view", parameters: [
            "town_name": townName,
            "town_id": townID
        ])
        Logger.shared.info("📊 Analytics: Town view - \(townName)")
    }
    
    func logCoffeeView(coffeeName: String, coffeeID: String, townID: String) {
        Analytics.logEvent("coffee_view", parameters: [
            "coffee_name": coffeeName,
            "coffee_id": coffeeID,
            "town_id": townID
        ])
        Logger.shared.info("📊 Analytics: Coffee view - \(coffeeName)")
    }
    
    func logAddToFavorites(coffeeID: String, coffeeName: String) {
        Analytics.logEvent("add_to_favorites", parameters: [
            "coffee_id": coffeeID,
            "coffee_name": coffeeName
        ])
        Logger.shared.info("📊 Analytics: Added to favorites - \(coffeeName)")
    }
    
    func logRemoveFromFavorites(coffeeID: String, coffeeName: String) {
        Analytics.logEvent("remove_from_favorites", parameters: [
            "coffee_id": coffeeID,
            "coffee_name": coffeeName
        ])
        Logger.shared.info("📊 Analytics: Removed from favorites - \(coffeeName)")
    }
    
    func logSearch(query: String, resultCount: Int) {
        Analytics.logEvent(AnalyticsEventSearch, parameters: [
            AnalyticsParameterSearchTerm: query,
            "result_count": resultCount
        ])
        Logger.shared.info("📊 Analytics: Search - \(query)")
    }
    
    // MARK: - User Properties
    
    func setUserProperties(userType: String, userID: String) {
        Analytics.setUserID(userID)
        Analytics.setUserProperty(userType, forName: "user_type")
        Logger.shared.info("📊 Analytics: User properties set")
    }
    
    func clearUserProperties() {
        Analytics.setUserID(nil)
        Logger.shared.info("📊 Analytics: User properties cleared")
    }
    
    // MARK: - Private Methods
    
    private func extractDomain(from email: String) -> String {
        let components = email.split(separator: "@")
        return components.count > 1 ? String(components[1]) : "unknown"
    }
}

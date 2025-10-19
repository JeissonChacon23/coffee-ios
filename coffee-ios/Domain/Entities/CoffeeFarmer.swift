//
//  CoffeeFarmer.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct CoffeeFarmer: Identifiable, Codable {
    let id: String
    let userID: String
    let name: String
    let description: String
    let townID: String
    let hectares: Double
    let altitude: Int
    let coffeeTypes: [String]
    let certifications: [String]
    let imageURL: String
    let latitude: Double
    let longitude: Double
    let status: FarmerStatus
    let annualProduction: Double // in kg
    let primaryContact: String
    let primaryPhone: String
    let primaryEmail: String
    let yearsOfExperience: Int
    let cultivationMethods: [String]
    let rating: Double
    let productCount: Int
    let isVerified: Bool
    let applicationDate: Date
    let verificationDate: Date?
    
    enum FarmerStatus: String, Codable {
        case pending = "Pending"
        case approved = "Approved"
        case rejected = "Rejected"
        case suspended = "Suspended"
    }
}

// MARK: - Preview
extension CoffeeFarmer {
    static var preview: CoffeeFarmer {
        CoffeeFarmer(
            id: UUID().uuidString,
            userID: UUID().uuidString,
            name: "Paradise Farm",
            description: "Traditional farm dedicated to growing superior quality arabica coffee.",
            townID: UUID().uuidString,
            hectares: 15.5,
            altitude: 1900,
            coffeeTypes: ["Arabica", "Bourbon"],
            certifications: ["Organic", "Fair Trade", "Rainforest Alliance"],
            imageURL: "https://example.com/farm.jpg",
            latitude: 6.2442,
            longitude: -75.5812,
            status: .approved,
            annualProduction: 5000,
            primaryContact: "Carlos García",
            primaryPhone: "3101234567",
            primaryEmail: "carlos@paraisfarm.com",
            yearsOfExperience: 20,
            cultivationMethods: ["Traditional shade-grown", "Composting"],
            rating: 4.9,
            productCount: 8,
            isVerified: true,
            applicationDate: Date(timeIntervalSinceNow: -86400 * 30),
            verificationDate: Date(timeIntervalSinceNow: -86400 * 25)
        )
    }
}

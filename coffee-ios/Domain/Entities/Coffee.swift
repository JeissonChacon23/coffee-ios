//
//  Coffee.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct Coffee: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let type: CoffeeType
    let roastLevel: RoastLevel
    let pricePerUnit: Double // Price per 453gr unit
    let availableQuantity: Int // Units available
    let imageURL: String
    let farmerID: String
    let townID: String
    let rating: Double
    let notes: [String]
    let altitude: Int
    let varieties: [String]
    let certifications: [String]
    let isFavorite: Bool
    let createdDate: Date
    
    enum CoffeeType: String, Codable {
        case arabica
        case robusta
        case hybrid
    }
    
    enum RoastLevel: String, Codable {
        case light = "Light"
        case medium = "Medium"
        case dark = "Dark"
        case veryDark = "Very Dark"
    }
}

// MARK: - Preview
extension Coffee {
    static var preview: Coffee {
        Coffee(
            id: UUID().uuidString,
            name: "Premium Antioquia Coffee",
            description: "High altitude coffee with chocolate and caramel notes, grown in the mountains of Antioquia.",
            type: .arabica,
            roastLevel: .medium,
            pricePerUnit: 45000, // Price per 453gr unit in COP
            availableQuantity: 50,
            imageURL: "https://example.com/coffee.jpg",
            farmerID: UUID().uuidString,
            townID: UUID().uuidString,
            rating: 4.8,
            notes: ["Chocolate", "Caramel", "Nuts"],
            altitude: 1800,
            varieties: ["Typica", "Bourbon"],
            certifications: ["Organic", "Fair Trade"],
            isFavorite: false,
            createdDate: Date()
        )
    }
}

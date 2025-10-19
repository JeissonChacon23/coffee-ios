//
//  Town.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct Town: Identifiable, Codable {
    let id: String
    let name: String
    let department: String
    let description: String
    let postalCode: String
    let latitude: Double
    let longitude: Double
    let imageURL: String
    let coffeeCount: Int
    let farmerCount: Int
    let isActive: Bool
    let createdDate: Date
    
    var coordinates: (latitude: Double, longitude: Double) {
        (latitude, longitude)
    }
}

// MARK: - Preview
extension Town {
    static var preview: Town {
        Town(
            id: UUID().uuidString,
            name: "Medellín",
            department: "Antioquia",
            description: "The world capital of coffee, home to the best coffee plantations in Colombia.",
            postalCode: "050001",
            latitude: 6.2442,
            longitude: -75.5812,
            imageURL: "https://example.com/medellin.jpg",
            coffeeCount: 15,
            farmerCount: 5,
            isActive: true,
            createdDate: Date()
        )
    }
}

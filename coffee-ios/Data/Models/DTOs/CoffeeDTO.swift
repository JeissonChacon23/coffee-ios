//
//  CoffeeDTO.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - CoffeeDTO (Data Transfer Object)
struct CoffeeDTO: Codable {
    let id: String
    let name: String
    let description: String
    let type: String // "arabica", "robusta", "hibrido"
    let roastLevel: String // "Claro", "Medio", "Oscuro", "Muy Oscuro"
    let pricePerKilo: Double
    let availableQuantity: Int
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case type
        case roastLevel
        case pricePerKilo
        case availableQuantity
        case imageURL
        case farmerID
        case townID
        case rating
        case notes
        case altitude
        case varieties
        case certifications
        case isFavorite
        case createdDate
    }
}

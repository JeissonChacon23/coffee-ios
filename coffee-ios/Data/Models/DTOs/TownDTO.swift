//
//  TownDTO.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - TownDTO (Data Transfer Object)
struct TownDTO: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case department
        case description
        case postalCode
        case latitude
        case longitude
        case imageURL
        case coffeeCount
        case farmerCount
        case isActive
        case createdDate
    }
}

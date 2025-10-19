//
//  CoffeeFarmerDTO.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - CoffeeFarmerDTO (Data Transfer Object)
struct CoffeeFarmerDTO: Codable {
    let id: String
    let userID: String
    let farmName: String
    let farmDescription: String
    let townID: String
    let hectares: Double
    let altitude: Int
    let coffeeTypes: [String]
    let certifications: [String]
    let farmImageURL: String
    let latitude: Double
    let longitude: Double
    let status: String // "pending", "approved", "rejected", "suspended"
    let annualProduction: Double
    let mainContact: String
    let contactPhone: String
    let contactEmail: String
    let experience: Int
    let cultivationMethods: [String]
    let rating: Double
    let productCount: Int
    let isVerified: Bool
    let applicationDate: Date
    let verificationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID
        case farmName
        case farmDescription
        case townID
        case hectares
        case altitude
        case coffeeTypes
        case certifications
        case farmImageURL
        case latitude
        case longitude
        case status
        case annualProduction
        case mainContact
        case contactPhone
        case contactEmail
        case experience
        case cultivationMethods
        case rating
        case productCount
        case isVerified
        case applicationDate
        case verificationDate
    }
}

//
//  UserDTO.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - UserDTO (Data Transfer Object)
struct UserDTO: Codable {
    var id: String
    let firstName: String
    let lastName: String
    let idCard: String
    var email: String
    let phone: String
    let state: String
    let city: String
    let zipCode: String
    let address: String
    let bornDate: Date
    let type: UserType
    var registrationDate: Date
    
    enum UserType: String, Codable {
        case customer
        case coffeeFarmer
        case admin
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case idCard
        case email
        case phone
        case state
        case city
        case zipCode
        case address
        case bornDate
        case type
        case registrationDate
    }
}

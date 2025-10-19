//
//  User.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let idCard: String
    let email: String
    let phone: String
    let state: String
    let city: String
    let zipCode: String
    let address: String
    let bornDate: Date
    let type: UserType
    let registrationDate: Date
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    enum UserType: String, Codable {
        case customer
        case coffeeFarmer
        case admin
    }
}

// MARK: - Preview
extension User {
    static var preview: User {
        User(
            id: UUID().uuidString,
            firstName: "Juan",
            lastName: "Pérez",
            idCard: "1234567890",
            email: "juan@example.com",
            phone: "3101234567",
            state: "Cundinamarca",
            city: "Bogotá",
            zipCode: "110111",
            address: "Cra 7 #45-89",
            bornDate: Date(timeIntervalSince1970: 631152000),
            type: .customer,
            registrationDate: Date()
        )
    }
}

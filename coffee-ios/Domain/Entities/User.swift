//
//  User.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let nombres: String
    let apellidos: String
    let cedula: String
    let correo: String
    let celular: String
    let departamento: String
    let ciudad: String
    let codigoPostal: String
    let direccion: String
    let fechaNacimiento: Date
    let tipo: UserType
    let fechaRegistro: Date
    
    var nombreCompleto: String {
        "\(nombres) \(apellidos)"
    }
    
    enum UserType: String, Codable {
        case cliente
        case caficultor
        case admin
    }
}

// MARK: - Preview
extension User {
    static var preview: User {
        User(
            id: UUID().uuidString,
            nombres: "Juan",
            apellidos: "Pérez",
            cedula: "1234567890",
            correo: "juan@example.com",
            celular: "3101234567",
            departamento: "Cundinamarca",
            ciudad: "Bogotá",
            codigoPostal: "110111",
            direccion: "Cra 7 #45-89",
            fechaNacimiento: Date(timeIntervalSince1970: 631152000),
            tipo: .cliente,
            fechaRegistro: Date()
        )
    }
}

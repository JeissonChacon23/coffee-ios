//
//  Coffee.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct Coffee: Identifiable, Codable {
    let id: String
    let nombre: String
    let descripcion: String
    let tipo: CoffeeType
    let nivelTostado: RoastLevel
    let precioKilo: Double
    let cantidadDisponible: Int
    let imagenURL: String
    let caficultorID: String
    let townID: String
    let calificacion: Double
    let notas: [String]
    let altitud: Int
    let variedades: [String]
    let certificaciones: [String]
    let esFavorito: Bool
    let fechaCreacion: Date
    
    enum CoffeeType: String, Codable {
        case arabica
        case robusta
        case hibrido
    }
    
    enum RoastLevel: String, Codable {
        case claro = "Claro"
        case medio = "Medio"
        case oscuro = "Oscuro"
        case muyOscuro = "Muy Oscuro"
    }
}

// MARK: - Preview
extension Coffee {
    static var preview: Coffee {
        Coffee(
            id: UUID().uuidString,
            nombre: "Café Supremo Antioqueño",
            descripcion: "Café de altura con notas de chocolate y caramelo, cultivado en las montañas de Antioquia.",
            tipo: .arabica,
            nivelTostado: .medio,
            precioKilo: 45000,
            cantidadDisponible: 50,
            imagenURL: "https://example.com/coffee.jpg",
            caficultorID: UUID().uuidString,
            townID: UUID().uuidString,
            calificacion: 4.8,
            notas: ["Chocolate", "Caramelo", "Nueces"],
            altitud: 1800,
            variedades: ["Typica", "Bourbon"],
            certificaciones: ["Orgánico", "Comercio Justo"],
            esFavorito: false,
            fechaCreacion: Date()
        )
    }
}

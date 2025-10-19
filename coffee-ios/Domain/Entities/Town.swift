//
//  Town.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct Town: Identifiable, Codable {
    let id: String
    let nombre: String
    let departamento: String
    let descripcion: String
    let codigoPostal: String
    let latitud: Double
    let longitud: Double
    let imagenURL: String
    let cafeCount: Int
    let caficultoresCount: Int
    let esActivo: Bool
    let fechaCreacion: Date
    
    var coordenadas: (lat: Double, lng: Double) {
        (latitud, longitud)
    }
}

// MARK: - Preview
extension Town {
    static var preview: Town {
        Town(
            id: UUID().uuidString,
            nombre: "Medellín",
            departamento: "Antioquia",
            descripcion: "La capital mundial del café, hogar de las mejores plantaciones de café de Colombia.",
            codigoPostal: "050001",
            latitud: 6.2442,
            longitud: -75.5812,
            imagenURL: "https://example.com/medellin.jpg",
            cafeCount: 15,
            caficultoresCount: 5,
            esActivo: true,
            fechaCreacion: Date()
        )
    }
}

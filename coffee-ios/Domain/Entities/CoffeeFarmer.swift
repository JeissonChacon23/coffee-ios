//
//  CoffeeFarmer.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct CoffeeFarmer: Identifiable, Codable {
    let id: String
    let userID: String
    let nombreFinca: String
    let descripcionFinca: String
    let townID: String
    let hectareas: Double
    let altitud: Int
    let tiposCafe: [String]
    let certificaciones: [String]
    let imagenFincaURL: String
    let latitud: Double
    let longitud: Double
    let estado: FarmerStatus
    let produccionAnual: Double
    let contactoPrincipal: String
    let telefonoContacto: String
    let correoContacto: String
    let experiencia: Int
    let metodosCultivo: [String]
    let calificacion: Double
    let numeroProductos: Int
    let estaVerificado: Bool
    let fechaSolicitud: Date
    let fechaVerificacion: Date?
    
    enum FarmerStatus: String, Codable {
        case pendiente = "Pendiente"
        case aprobado = "Aprobado"
        case rechazado = "Rechazado"
        case suspendido = "Suspendido"
    }
}

// MARK: - Preview
extension CoffeeFarmer {
    static var preview: CoffeeFarmer {
        CoffeeFarmer(
            id: UUID().uuidString,
            userID: UUID().uuidString,
            nombreFinca: "Finca El Paraíso",
            descripcionFinca: "Finca tradicional dedicada al cultivo de café arabica de calidad superior.",
            townID: UUID().uuidString,
            hectareas: 15.5,
            altitud: 1900,
            tiposCafe: ["Arabica", "Bourbon"],
            certificaciones: ["Orgánico", "Comercio Justo", "Rainforest Alliance"],
            imagenFincaURL: "https://example.com/finca.jpg",
            latitud: 6.2442,
            longitud: -75.5812,
            estado: .aprobado,
            produccionAnual: 5000,
            contactoPrincipal: "Carlos García",
            telefonoContacto: "3101234567",
            correoContacto: "carlos@fincaparaiso.com",
            experiencia: 20,
            metodosCultivo: ["Sombrío tradicional", "Compostaje"],
            calificacion: 4.9,
            numeroProductos: 8,
            estaVerificado: true,
            fechaSolicitud: Date(timeIntervalSinceNow: -86400 * 30),
            fechaVerificacion: Date(timeIntervalSinceNow: -86400 * 25)
        )
    }
}

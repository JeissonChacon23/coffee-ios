//
//  CedulaValidator.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct CedulaValidator {
    static func validate(_ cedula: String) -> ValidationResult {
        let trimmedCedula = cedula.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedCedula.isEmpty else {
            return .invalid(message: "La cédula es requerida")
        }
        
        guard trimmedCedula.isValidCedula else {
            return .invalid(message: "La cédula debe contener solo números")
        }
        
        return .valid
    }
}

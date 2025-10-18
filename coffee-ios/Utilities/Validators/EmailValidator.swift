//
//  EmailValidator.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - Email Validator
struct EmailValidator {
    static func validate(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedEmail.isEmpty else {
            return .invalid(message: "El correo electrónico es requerido")
        }
        
        guard trimmedEmail.isValidEmail else {
            return .invalid(message: "Por favor ingresa un correo electrónico válido")
        }
        
        return .valid
    }
}

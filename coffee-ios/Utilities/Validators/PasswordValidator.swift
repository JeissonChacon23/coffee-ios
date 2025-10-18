//
//  PasswordValidator.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - Password Validator
struct PasswordValidator {
    static func validate(_ password: String) -> ValidationResult {
        guard !password.isEmpty else {
            return .invalid(message: "La contraseña es requerida")
        }
        
        guard password.count >= AppConstants.Validation.minPasswordLength else {
            return .invalid(message: "La contraseña debe tener al menos \(AppConstants.Validation.minPasswordLength) caracteres")
        }
        
        return .valid
    }
    
    static func validateMatch(_ password: String, _ confirmPassword: String) -> ValidationResult {
        guard password == confirmPassword else {
            return .invalid(message: "Las contraseñas no coinciden")
        }
        
        return .valid
    }
}

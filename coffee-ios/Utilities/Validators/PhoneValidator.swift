//
//  PhoneValidator.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

struct PhoneValidator {
    static func validate(_ phone: String) -> ValidationResult {
        let trimmedPhone = phone.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedPhone.isEmpty else {
            return .invalid(message: "El celular es requerido")
        }
        
        guard trimmedPhone.isValidPhone else {
            return .invalid(message: "El celular debe contener 10 dígitos")
        }
        
        return .valid
    }
}

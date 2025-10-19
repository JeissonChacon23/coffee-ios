//
//  String+Extension.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

extension String {
    // MARK: - Validation Methods
    var isValidEmail: Bool {
        let regex: String = AppConstants.Validation.emailRegex
        return self.range(of: regex, options: .regularExpression) != nil
    }
    
    var isValidPassword: Bool {
        return self.count >= AppConstants.Validation.minPasswordLength
    }
    
    var isValidPhone: Bool {
        let regex: String = AppConstants.Validation.phoneRegex
        return self.range(of: regex, options: .regularExpression) != nil
    }
    
    var isValidCedula: Bool {
        let regex: String = AppConstants.Validation.cedulaRegex
        return self.range(of: regex, options: .regularExpression) != nil
    }
    
    // MARK: - Formatting Methods
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var isTrimmedEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Case Methods
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    // MARK: - Mask Methods (Para cédula o teléfono)
    func mask(pattern: String) -> String {
        var result = ""
        var index = startIndex
        
        for ch in pattern {
            if ch == "#" {
                if index < endIndex {
                    result.append(self[index])
                    index = self.index(after: index)
                }
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
}

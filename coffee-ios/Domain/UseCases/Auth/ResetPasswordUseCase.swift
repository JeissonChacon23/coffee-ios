//
//  ResetPasswordUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - ResetPasswordUseCase Input
struct ResetPasswordUseCaseInput {
    let email: String
}

// MARK: - ResetPasswordUseCase Output
struct ResetPasswordUseCaseOutput {
    let message: String
    let emailSent: String
}

// MARK: - ResetPasswordUseCase Protocol
protocol ResetPasswordUseCaseProtocol {
    /// Ejecuta el caso de uso de recuperación de contraseña
    /// - Parameter input: Email del usuario para recuperar contraseña
    /// - Returns: Mensaje de confirmación
    func execute(input: ResetPasswordUseCaseInput) async throws -> ResetPasswordUseCaseOutput
}

// MARK: - ResetPasswordUseCase Implementation
class ResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    private let authRepository: IAuthRepository
    
    init(authRepository: IAuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(input: ResetPasswordUseCaseInput) async throws -> ResetPasswordUseCaseOutput {
        // Validar email
        let emailValidation = EmailValidator.validate(input.email)
        guard emailValidation.isValid else {
            throw ResetPasswordUseCaseError.invalidEmail(emailValidation.errorMessage ?? "Email inválido")
        }
        
        // Enviar email de recuperación
        try await authRepository.resetPassword(email: input.email.trimmed)
        
        Logger.shared.info("📧 Email de recuperación enviado a: \(input.email)")
        
        return ResetPasswordUseCaseOutput(
            message: "Se ha enviado un enlace de recuperación a tu correo electrónico",
            emailSent: input.email.trimmed
        )
    }
}

// MARK: - ResetPasswordUseCase Errors
enum ResetPasswordUseCaseError: LocalizedError {
    case invalidEmail(String)
    case emailNotFound
    case tooManyRequests
    case resetFailed(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail(let message):
            return message
        case .emailNotFound:
            return "No existe una cuenta con este email"
        case .tooManyRequests:
            return "Demasiadas solicitudes de recuperación. Intenta más tarde"
        case .resetFailed(let message):
            return "Error al solicitar recuperación: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

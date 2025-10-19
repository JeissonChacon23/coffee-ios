//
//  SignInUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - SignInUseCase Input
struct SignInUseCaseInput {
    let email: String
    let password: String
}

// MARK: - SignInUseCase Output
struct SignInUseCaseOutput {
    let user: User
    let message: String
}

// MARK: - SignInUseCase Protocol
protocol SignInUseCaseProtocol {
    /// Ejecuta el caso de uso de inicio de sesión
    /// - Parameter input: Email y contraseña del usuario
    /// - Returns: Usuario autenticado y mensaje de confirmación
    func execute(input: SignInUseCaseInput) async throws -> SignInUseCaseOutput
}

// MARK: - SignInUseCase Implementation
class SignInUseCase: SignInUseCaseProtocol {
    private let authRepository: IAuthRepository
    
    init(authRepository: IAuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(input: SignInUseCaseInput) async throws -> SignInUseCaseOutput {
        // Validar email
        let emailValidation = EmailValidator.validate(input.email)
        guard emailValidation.isValid else {
            throw SignInUseCaseError.invalidEmail(emailValidation.errorMessage ?? "Email inválido")
        }
        
        // Validar que la contraseña no esté vacía
        guard !input.password.isEmpty else {
            throw SignInUseCaseError.emptyPassword
        }
        
        // Intentar iniciar sesión
        let user = try await authRepository.signIn(
            email: input.email.trimmed,
            password: input.password
        )
        
        Logger.shared.info("✅ Usuario autenticado: \(user.email)")
        
        return SignInUseCaseOutput(
            user: user,
            message: "Bienvenido de vuelta, \(user.fullName)"
        )
    }
}

// MARK: - SignInUseCase Errors
enum SignInUseCaseError: LocalizedError {
    case invalidEmail(String)
    case emptyPassword
    case invalidCredentials
    case userNotFound
    case userDisabled
    case tooManyAttempts
    case authenticationFailed(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail(let message):
            return message
        case .emptyPassword:
            return "La contraseña es requerida"
        case .invalidCredentials:
            return "Email o contraseña incorrectos"
        case .userNotFound:
            return "No existe una cuenta con este email"
        case .userDisabled:
            return "Esta cuenta ha sido deshabilitada"
        case .tooManyAttempts:
            return "Demasiados intentos de inicio de sesión. Intenta más tarde"
        case .authenticationFailed(let message):
            return "Error de autenticación: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

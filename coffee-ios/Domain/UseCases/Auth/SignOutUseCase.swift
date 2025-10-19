//
//  SignOutUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - SignOutUseCase Output
struct SignOutUseCaseOutput {
    let message: String
}

// MARK: - SignOutUseCase Protocol
protocol SignOutUseCaseProtocol {
    /// Ejecuta el caso de uso de cierre de sesión
    /// - Returns: Mensaje de confirmación
    func execute() throws -> SignOutUseCaseOutput
}

// MARK: - SignOutUseCase Implementation
class SignOutUseCase: SignOutUseCaseProtocol {
    private let authRepository: IAuthRepository
    
    init(authRepository: IAuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() throws -> SignOutUseCaseOutput {
        do {
            try authRepository.signOut()
            Logger.shared.info("👋 Usuario cerró sesión")
            
            return SignOutUseCaseOutput(
                message: "Sesión cerrada exitosamente"
            )
        } catch {
            Logger.shared.error("❌ Error al cerrar sesión: \(error.localizedDescription)")
            throw SignOutUseCaseError.signOutFailed(error.localizedDescription)
        }
    }
}

// MARK: - SignOutUseCase Errors
enum SignOutUseCaseError: LocalizedError {
    case signOutFailed(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .signOutFailed(let message):
            return "Error al cerrar sesión: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

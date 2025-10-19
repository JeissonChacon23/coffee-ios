//
//  SignUpUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - SignUpUseCase Input
struct SignUpUseCaseInput {
    let email: String
    let password: String
    let name: String
    let lastName: String
    let idCard: String
    let phone: String
    let state: String
    let city: String
    let zipCode: String
    let address: String
    let bornDate: Date
}

// MARK: - SignUpUseCase Output
struct SignUpUseCaseOutput {
    let user: User
    let message: String
}

// MARK: - SignUpUseCase Protocol
protocol SignUpUseCaseProtocol {
    /// Executes the sign up use case
    /// - Parameter input: Required data for registration
    /// - Returns: Registered user and confirmation message
    func execute(input: SignUpUseCaseInput) async throws -> SignUpUseCaseOutput
}

// MARK: - SignUpUseCase Implementation
class SignUpUseCase: SignUpUseCaseProtocol {
    private let authRepository: IAuthRepository
    
    init(authRepository: IAuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(input: SignUpUseCaseInput) async throws -> SignUpUseCaseOutput {
        // Validate email
        let emailValidation = EmailValidator.validate(input.email)
        guard emailValidation.isValid else {
            throw SignUpUseCaseError.invalidEmail(emailValidation.errorMessage ?? "Invalid email")
        }
        
        // Validate password
        let passwordValidation = PasswordValidator.validate(input.password)
        guard passwordValidation.isValid else {
            throw SignUpUseCaseError.weakPassword(passwordValidation.errorMessage ?? "Weak password")
        }
        
        // Validate cedula
        let cedulaValidation = CedulaValidator.validate(input.idCard)
        guard cedulaValidation.isValid else {
            throw SignUpUseCaseError.invalidCedula(cedulaValidation.errorMessage ?? "Invalid ID card")
        }
        
        // Validate phone
        let phoneValidation = PhoneValidator.validate(input.phone)
        guard phoneValidation.isValid else {
            throw SignUpUseCaseError.invalidPhone(phoneValidation.errorMessage ?? "Invalid phone")
        }
        
        // Create user
        let newUser = User(
            id: "",
            firstName: input.name.trimmed,
            lastName: input.lastName.trimmed,
            idCard: input.idCard.trimmed,
            email: input.email.trimmed,
            phone: input.phone.trimmed,
            state: input.state.trimmed,
            city: input.city.trimmed,
            zipCode: input.zipCode.trimmed,
            address: input.address.trimmed,
            bornDate: input.bornDate,
            type: .customer,
            registrationDate: Date()
        )
        
        // Register in repository
        let registeredUser = try await authRepository.signUp(
            email: input.email.trimmed,
            password: input.password,
            user: newUser
        )
        
        Logger.shared.info("✅ User registered successfully: \(registeredUser.email)")
        
        return SignUpUseCaseOutput(
            user: registeredUser,
            message: "Welcome to Town's Coffee, \(registeredUser.firstName)"
        )
    }
}

// MARK: - SignUpUseCase Errors
enum SignUpUseCaseError: LocalizedError {
    case invalidEmail(String)
    case weakPassword(String)
    case invalidCedula(String)
    case invalidPhone(String)
    case registrationFailed(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail(let message):
            return message
        case .weakPassword(let message):
            return message
        case .invalidCedula(let message):
            return message
        case .invalidPhone(let message):
            return message
        case .registrationFailed(let message):
            return "Registration error: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

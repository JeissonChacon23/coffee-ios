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
    /// Ejecuta el caso de uso de registro
    /// - Parameter input: Datos de entrada necesarios para el registro
    /// - Returns: Usuario registrado y mensaje de confirmación
    func execute(input: SignUpUseCaseInput) async throws -> SignUpUseCaseOutput
}

// MARK: - SignUpUseCase Implementation
class SignUpUseCase: SignUpUseCaseProtocol {
    private let authRepository: IAuthRepository
    
    init(authRepository: IAuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(input: SignUpUseCaseInput) async throws -> SignUpUseCaseOutput {
        // Validar email
        let emailValidation = EmailValidator.validate(input.email)
        guard emailValidation.isValid else {
            throw SignUpUseCaseError.invalidEmail(emailValidation.errorMessage ?? "Email inválido")
        }
        
        // Validar contraseña
        let passwordValidation = PasswordValidator.validate(input.password)
        guard passwordValidation.isValid else {
            throw SignUpUseCaseError.weakPassword(passwordValidation.errorMessage ?? "Contraseña débil")
        }
        
        // Validar cédula
        let cedulaValidation = CedulaValidator.validate(input.idCard)
        guard cedulaValidation.isValid else {
            throw SignUpUseCaseError.invalidCedula(cedulaValidation.errorMessage ?? "Cédula inválida")
        }
        
        // Validar celular
        let phoneValidation = PhoneValidator.validate(input.phone)
        guard phoneValidation.isValid else {
            throw SignUpUseCaseError.invalidPhone(phoneValidation.errorMessage ?? "Celular inválido")
        }
        
        // Crear el usuario
        let newUser = User(
            id: "",
            nombres: input.name.trimmed,
            apellidos: input.lastName.trimmed,
            cedula: input.idCard.trimmed,
            correo: input.email.trimmed,
            celular: input.phone.trimmed,
            departamento: input.state.trimmed,
            ciudad: input.city.trimmed,
            codigoPostal: input.zipCode.trimmed,
            direccion: input.address.trimmed,
            fechaNacimiento: input.bornDate,
            tipo: .cliente,
            fechaRegistro: Date()
        )
        
        // Registrar en el repositorio
        let registeredUser = try await authRepository.signUp(
            email: input.email.trimmed,
            password: input.password,
            user: newUser
        )
        
        Logger.shared.info("✅ Usuario registrado exitosamente: \(registeredUser.correo)")
        
        return SignUpUseCaseOutput(
            user: registeredUser,
            message: "Bienvenido a Town's Coffee, \(registeredUser.nombres)"
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
            return "Error en el registro: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

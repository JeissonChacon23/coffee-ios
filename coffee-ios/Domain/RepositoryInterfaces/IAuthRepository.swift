//
//  IAuthRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

protocol IAuthRepository {
    // MARK: - Authentication Methods
    
    /// Registra un nuevo usuario
    /// - Parameters:
    ///   - email: Correo electrónico del usuario
    ///   - password: Contraseña del usuario
    ///   - user: Datos del perfil del usuario
    /// - Returns: El usuario registrado
    func signUp(email: String, password: String, user: User) async throws -> User
    
    /// Inicia sesión con email y contraseña
    /// - Parameters:
    ///   - email: Correo electrónico del usuario
    ///   - password: Contraseña del usuario
    /// - Returns: El usuario autenticado
    func signIn(email: String, password: String) async throws -> User
    
    /// Cierra la sesión del usuario actual
    func signOut() throws
    
    /// Envía un email de recuperación de contraseña
    /// - Parameter email: Correo electrónico del usuario
    func resetPassword(email: String) async throws
    
    // MARK: - User Profile Methods
    
    /// Obtiene el perfil del usuario actual
    /// - Parameter uid: ID del usuario
    /// - Returns: El perfil del usuario
    func getCurrentUser(uid: String) async throws -> User
    
    /// Actualiza el perfil del usuario
    /// - Parameter user: Usuario con datos actualizados
    func updateUserProfile(_ user: User) async throws
    
    /// Verifica si el usuario está autenticado
    var isAuthenticated: Bool { get }
    
    /// Obtiene el ID del usuario actual
    var currentUserID: String? { get }
    
    // MARK: - Authentication State
    
    /// Publisher que emite cambios en el estado de autenticación
    var authStatePublisher: AnyPublisher<AuthState, Never> { get }
}

// MARK: - AuthState
enum AuthState {
    case authenticated(user: User)
    case unauthenticated
    case loading
    case error(message: String)
}

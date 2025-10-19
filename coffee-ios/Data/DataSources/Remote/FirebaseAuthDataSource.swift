//
//  FirebaseAuthDataSource.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

// MARK: - FirebaseAuthDataSource Protocol
protocol FirebaseAuthDataSourceProtocol {
    func signUp(email: String, password: String, userDTO: UserDTO) async throws -> UserDTO
    func signIn(email: String, password: String) async throws -> UserDTO
    func signOut() throws
    func resetPassword(email: String) async throws
    func getCurrentUser(uid: String) async throws -> UserDTO
    func updateUserProfile(_ userDTO: UserDTO) async throws
    var isAuthenticated: Bool { get }
    var currentUserID: String? { get }
    var authStatePublisher: AnyPublisher<AuthStateDTO, Never> { get }
}

// MARK: - AuthStateDTO
enum AuthStateDTO {
    case authenticated(user: UserDTO)
    case unauthenticated
    case loading
    case error(message: String)
}

// MARK: - FirebaseAuthDataSource Implementation
class FirebaseAuthDataSource: FirebaseAuthDataSourceProtocol {
    private let db = Firestore.firestore()
    private let authStateSubject = PassthroughSubject<AuthStateDTO, Never>()
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }
    
    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    var authStatePublisher: AnyPublisher<AuthStateDTO, Never> {
        authStateSubject.eraseToAnyPublisher()
    }
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Setup
    private func setupAuthStateListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                Task {
                    do {
                        let userDTO = try await self?.getCurrentUser(uid: user.uid)
                        if let userDTO = userDTO {
                            self?.authStateSubject.send(.authenticated(user: userDTO))
                        }
                    } catch {
                        self?.authStateSubject.send(.error(message: error.localizedDescription))
                    }
                }
            } else {
                self?.authStateSubject.send(.unauthenticated)
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, userDTO: UserDTO) async throws -> UserDTO {
        // Create user in Firebase Auth
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = result.user.uid
        
        // Prepare user DTO with uid
        var updatedUserDTO = userDTO
        updatedUserDTO.id = uid
        updatedUserDTO.email = email
        updatedUserDTO.registrationDate = Date()
        
        // Save to Firestore
        do {
            try db.collection(AppConstants.FirebaseCollections.users)
                .document(uid)
                .setData(from: updatedUserDTO)
        } catch {
            // If Firestore fails, delete the user from Auth
            try await result.user.delete()
            throw AuthDataSourceError.firestoreError(error.localizedDescription)
        }
        
        Logger.shared.info("✅ User signed up successfully: \(email)")
        return updatedUserDTO
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> UserDTO {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let userDTO = try await getCurrentUser(uid: result.user.uid)
        
        Logger.shared.info("✅ User signed in: \(email)")
        return userDTO
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
        authStateSubject.send(.unauthenticated)
        Logger.shared.info("👋 User signed out")
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
        Logger.shared.info("📧 Password reset email sent to: \(email)")
    }
    
    // MARK: - Get Current User
    func getCurrentUser(uid: String) async throws -> UserDTO {
        let document = try await db.collection(AppConstants.FirebaseCollections.users)
            .document(uid)
            .getDocument()
        
        guard let userDTO = try document.data(as: UserDTO?.self) else {
            throw AuthDataSourceError.userNotFound
        }
        
        Logger.shared.info("✅ User profile fetched: \(userDTO.email)")
        return userDTO
    }
    
    // MARK: - Update User Profile
    func updateUserProfile(_ userDTO: UserDTO) async throws {
        try db.collection(AppConstants.FirebaseCollections.users)
            .document(userDTO.id)
            .setData(from: userDTO, merge: true)
        
        Logger.shared.info("✅ User profile updated: \(userDTO.id)")
    }
}

// MARK: - AuthDataSourceError
enum AuthDataSourceError: LocalizedError {
    case invalidEmail
    case weakPassword
    case userNotFound
    case userAlreadyExists
    case firestoreError(String)
    case authenticationFailed(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email format"
        case .weakPassword:
            return "Password is too weak"
        case .userNotFound:
            return "User profile not found"
        case .userAlreadyExists:
            return "User already exists"
        case .firestoreError(let message):
            return "Database error: \(message)"
        case .authenticationFailed(let message):
            return "Authentication failed: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

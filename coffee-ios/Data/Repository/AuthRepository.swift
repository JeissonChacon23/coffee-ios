//
//  AuthRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

// MARK: - AuthRepository Implementation
class AuthRepository: IAuthRepository {
    private let dataSource: FirebaseAuthDataSourceProtocol
    private let userMapper: UserMapper
    
    init(
        dataSource: FirebaseAuthDataSourceProtocol,
        userMapper: UserMapper = UserMapper()
    ) {
        self.dataSource = dataSource
        self.userMapper = userMapper
    }
    
    // MARK: - Authentication Methods
    
    func signUp(email: String, password: String, user: User) async throws -> User {
        let userDTO = userMapper.mapToDTO(user)
        let resultDTO = try await dataSource.signUp(email: email, password: password, userDTO: userDTO)
        return userMapper.mapToDomain(resultDTO)
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let userDTO = try await dataSource.signIn(email: email, password: password)
        return userMapper.mapToDomain(userDTO)
    }
    
    func signOut() throws {
        try dataSource.signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await dataSource.resetPassword(email: email)
    }
    
    // MARK: - User Profile Methods
    
    func getCurrentUser(uid: String) async throws -> User {
        let userDTO = try await dataSource.getCurrentUser(uid: uid)
        return userMapper.mapToDomain(userDTO)
    }
    
    func updateUserProfile(_ user: User) async throws {
        let userDTO = userMapper.mapToDTO(user)
        try await dataSource.updateUserProfile(userDTO)
    }
    
    // MARK: - Authentication State
    
    var isAuthenticated: Bool {
        dataSource.isAuthenticated
    }
    
    var currentUserID: String? {
        dataSource.currentUserID
    }
    
    var authStatePublisher: AnyPublisher<AuthState, Never> {
        dataSource.authStatePublisher
            .map { [weak self] authStateDTO -> AuthState in
                switch authStateDTO {
                case .authenticated(let userDTO):
                    let user = self?.userMapper.mapToDomain(userDTO) ?? User.preview
                    return .authenticated(user: user)
                case .unauthenticated:
                    return .unauthenticated
                case .loading:
                    return .loading
                case .error(let message):
                    return .error(message: message)
                }
            }
            .eraseToAnyPublisher()
    }
}

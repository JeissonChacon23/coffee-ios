//
//  AuthViewModelFactory.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - AuthViewModelFactory
class AuthViewModelFactory {
    static func makeAuthViewModel(container: DIContainer = DIContainer.shared) -> AuthViewModel {
        return AuthViewModel(
            signUpUseCase: container.makeSignUpUseCase(),
            signInUseCase: container.makeSignInUseCase(),
            resetPasswordUseCase: container.makeResetPasswordUseCase(),
            signOutUseCase: container.makeSignOutUseCase(),
            authRepository: container.makeAuthRepository()
        )
    }
}

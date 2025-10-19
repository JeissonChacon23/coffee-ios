//
//  AuthViewModel.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

// MARK: - AuthViewModel
@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let signUpUseCase: SignUpUseCaseProtocol
    private let signInUseCase: SignInUseCaseProtocol
    private let resetPasswordUseCase: ResetPasswordUseCaseProtocol
    private let signOutUseCase: SignOutUseCaseProtocol
    private let authRepository: IAuthRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        signUpUseCase: SignUpUseCaseProtocol,
        signInUseCase: SignInUseCaseProtocol,
        resetPasswordUseCase: ResetPasswordUseCaseProtocol,
        signOutUseCase: SignOutUseCaseProtocol,
        authRepository: IAuthRepository
    ) {
        self.signUpUseCase = signUpUseCase
        self.signInUseCase = signInUseCase
        self.resetPasswordUseCase = resetPasswordUseCase
        self.signOutUseCase = signOutUseCase
        self.authRepository = authRepository
        
        setupAuthStateListener()
    }
    
    // MARK: - Setup
    private func setupAuthStateListener() {
        authRepository.authStatePublisher
            .sink { [weak self] authState in
                switch authState {
                case .authenticated(let user):
                    self?.currentUser = user
                    self?.isAuthenticated = true
                case .unauthenticated:
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                case .loading:
                    self?.isLoading = true
                case .error(let message):
                    self?.errorMessage = message
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Sign Up
    func signUp(input: SignUpUseCaseInput) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let output = try await signUpUseCase.execute(input: input)
            currentUser = output.user
            isAuthenticated = true
            successMessage = output.message
            Logger.shared.info("✅ Sign up successful")
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            Logger.shared.error("❌ Sign up failed: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Sign In
    func signIn(input: SignInUseCaseInput) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let output = try await signInUseCase.execute(input: input)
            currentUser = output.user
            isAuthenticated = true
            successMessage = output.message
            Logger.shared.info("✅ Sign in successful")
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            Logger.shared.error("❌ Sign in failed: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Reset Password
    func resetPassword(input: ResetPasswordUseCaseInput) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let output = try await resetPasswordUseCase.execute(input: input)
            successMessage = output.message
            Logger.shared.info("✅ Password reset email sent")
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            Logger.shared.error("❌ Password reset failed: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        errorMessage = nil
        successMessage = nil
        
        do {
            let output = try signOutUseCase.execute()
            currentUser = nil
            isAuthenticated = false
            successMessage = output.message
            Logger.shared.info("✅ Sign out successful")
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            Logger.shared.error("❌ Sign out failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Utility Methods
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
}

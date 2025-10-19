//
//  DIContainer.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - DIContainer (Singleton)
class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Data Sources
    func makeFirebaseAuthDataSource() -> FirebaseAuthDataSourceProtocol {
        return FirebaseAuthDataSource()
    }
    
    // MARK: - Repositories
    func makeAuthRepository() -> IAuthRepository {
        let dataSource = makeFirebaseAuthDataSource()
        let mapper = UserMapper()
        return AuthRepository(dataSource: dataSource, userMapper: mapper)
    }
    
    // MARK: - Use Cases - Auth
    func makeSignUpUseCase() -> SignUpUseCaseProtocol {
        let authRepository = makeAuthRepository()
        return SignUpUseCase(authRepository: authRepository)
    }
    
    func makeSignInUseCase() -> SignInUseCaseProtocol {
        let authRepository = makeAuthRepository()
        return SignInUseCase(authRepository: authRepository)
    }
    
    func makeResetPasswordUseCase() -> ResetPasswordUseCaseProtocol {
        let authRepository = makeAuthRepository()
        return ResetPasswordUseCase(authRepository: authRepository)
    }
    
    func makeSignOutUseCase() -> SignOutUseCaseProtocol {
        let authRepository = makeAuthRepository()
        return SignOutUseCase(authRepository: authRepository)
    }
    
    // MARK: - Use Cases - Towns (Placeholder - será implementado después)
    func makeGetTownsUseCase() -> GetTownsUseCaseProtocol? {
        // Por ahora retorna nil hasta que implementemos TownRepository
        return nil
    }
    
    func makeGetTownDetailUseCase() -> GetTownDetailUseCaseProtocol? {
        // Por ahora retorna nil hasta que implementemos TownRepository
        return nil
    }
    
    // MARK: - Use Cases - Coffees (Placeholder - será implementado después)
    func makeGetCoffeesUseCase() -> GetCoffeesUseCaseProtocol? {
        // Por ahora retorna nil hasta que implementemos CoffeeRepository
        return nil
    }
    
    func makeManageFavoritesUseCase() -> ManageFavoritesUseCaseProtocol? {
        // Por ahora retorna nil hasta que implementemos CoffeeRepository
        return nil
    }
    
    // MARK: - Repositories Placeholder (Se implementarán después en Opción B)
    // Aquí es donde irán TownRepository, CoffeeRepository, CoffeeFarmerRepository
    // cuando las implementemos en el Data Layer
}

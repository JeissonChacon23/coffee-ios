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
    
    func makeFirebaseTownDataSource() -> FirebaseTownDataSourceProtocol {
        return FirebaseTownDataSource()
    }
    
    func makeFirebaseCoffeeDataSource() -> FirebaseCoffeeDataSourceProtocol {
        return FirebaseCoffeeDataSource()
    }
    
    func makeFirebaseCoffeeFarmerDataSource() -> FirebaseCoffeeFarmerDataSourceProtocol {
        return FirebaseCoffeeFarmerDataSource()
    }
    
    // MARK: - Repositories
    func makeAuthRepository() -> IAuthRepository {
        let dataSource = makeFirebaseAuthDataSource()
        let mapper = UserMapper()
        return AuthRepository(dataSource: dataSource, userMapper: mapper)
    }
    
    func makeTownRepository() -> ITownRepository {
        let dataSource = makeFirebaseTownDataSource()
        let mapper = TownMapper()
        return TownRepository(dataSource: dataSource, mapper: mapper)
    }
    
    func makeCoffeeRepository() -> ICoffeeRepository {
        let dataSource = makeFirebaseCoffeeDataSource()
        let mapper = CoffeeMapper()
        return CoffeeRepository(dataSource: dataSource, mapper: mapper)
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
    
    // MARK: - Use Cases - Towns
    func makeGetTownsUseCase() -> GetTownsUseCaseProtocol {
        let townRepository = makeTownRepository()
        return GetTownsUseCase(townRepository: townRepository)
    }
    
    func makeGetTownDetailUseCase() -> GetTownDetailUseCaseProtocol {
        let townRepository = makeTownRepository()
        let coffeeRepository = makeCoffeeRepository()
        let farmerRepository = makeCoffeeFarmerRepository()
        return GetTownDetailUseCase(
            townRepository: townRepository,
            coffeeRepository: coffeeRepository,
            farmerRepository: farmerRepository
        )
    }
    
    // MARK: - Use Cases - Coffees
    func makeGetCoffeesUseCase() -> GetCoffeesUseCaseProtocol {
        let coffeeRepository = makeCoffeeRepository()
        return GetCoffeesUseCase(coffeeRepository: coffeeRepository)
    }
    
    func makeManageFavoritesUseCase() -> ManageFavoritesUseCaseProtocol {
        let coffeeRepository = makeCoffeeRepository()
        return ManageFavoritesUseCase(coffeeRepository: coffeeRepository)
    }
    
    // MARK: - Repositories Placeholder (CoffeeFarmer - será implementado después)
    private func makeCoffeeFarmerRepository() -> ICoffeeFarmerRepository {
        // Placeholder - se implementará después
        fatalError("CoffeeFarmerRepository not yet implemented")
    }
}

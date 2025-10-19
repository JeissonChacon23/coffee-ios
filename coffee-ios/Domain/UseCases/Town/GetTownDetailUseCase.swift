//
//  GetTownDetailUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - GetTownDetailUseCase Input
struct GetTownDetailUseCaseInput {
    let townID: String
}

// MARK: - GetTownDetailUseCase Output
struct GetTownDetailUseCaseOutput {
    let town: Town
    let coffees: [Coffee]
    let farmers: [CoffeeFarmer]
}

// MARK: - GetTownDetailUseCase Protocol
protocol GetTownDetailUseCaseProtocol {
    /// Obtiene los detalles completos de un town
    /// - Parameter input: ID del town
    /// - Returns: Datos del town, cafés y caficultores
    func execute(input: GetTownDetailUseCaseInput) async throws -> GetTownDetailUseCaseOutput
}

// MARK: - GetTownDetailUseCase Implementation
class GetTownDetailUseCase: GetTownDetailUseCaseProtocol {
    private let townRepository: ITownRepository
    private let coffeeRepository: ICoffeeRepository
    private let farmerRepository: ICoffeeFarmerRepository
    
    init(
        townRepository: ITownRepository,
        coffeeRepository: ICoffeeRepository,
        farmerRepository: ICoffeeFarmerRepository
    ) {
        self.townRepository = townRepository
        self.coffeeRepository = coffeeRepository
        self.farmerRepository = farmerRepository
    }
    
    func execute(input: GetTownDetailUseCaseInput) async throws -> GetTownDetailUseCaseOutput {
        // Validar que el ID no esté vacío
        guard !input.townID.isEmpty else {
            throw GetTownDetailUseCaseError.invalidTownID
        }
        
        // Obtener datos en paralelo para mejor rendimiento
        async let townTask = townRepository.fetchTown(byID: input.townID)
        async let coffeesTask = coffeeRepository.fetchCoffees(byTownID: input.townID)
        async let farmersTask = farmerRepository.fetchCoffeeFarmers(byTownID: input.townID)
        
        let town = try await townTask
        let coffees = try await coffeesTask
        let farmers = try await farmersTask
        
        Logger.shared.info("✅ Detalles del town '\(town.nombre)' obtenidos: \(coffees.count) cafés, \(farmers.count) caficultores")
        
        return GetTownDetailUseCaseOutput(
            town: town,
            coffees: coffees,
            farmers: farmers
        )
    }
}

// MARK: - GetTownDetailUseCase Errors
enum GetTownDetailUseCaseError: LocalizedError {
    case invalidTownID
    case townNotFound
    case fetchFailed(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidTownID:
            return "El ID del town es inválido"
        case .townNotFound:
            return "El town no existe"
        case .fetchFailed(let message):
            return "Error al obtener detalles: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

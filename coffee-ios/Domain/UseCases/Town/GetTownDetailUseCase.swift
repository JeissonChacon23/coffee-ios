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
    /// Gets complete details of a town
    /// - Parameter input: Town ID
    /// - Returns: Town data, coffees and farmers
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
        // Validate ID is not empty
        guard !input.townID.isEmpty else {
            throw GetTownDetailUseCaseError.invalidTownID
        }
        
        // Fetch data in parallel for better performance
        async let townTask = townRepository.fetchTown(byID: input.townID)
        async let coffeesTask = coffeeRepository.fetchCoffees(byTownID: input.townID)
        async let farmersTask = farmerRepository.fetchCoffeeFarmers(byTownID: input.townID)
        
        let town = try await townTask
        let coffees = try await coffeesTask
        let farmers = try await farmersTask
        
        Logger.shared.info("✅ Town '\(town.name)' details fetched: \(coffees.count) coffees, \(farmers.count) farmers")
        
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
            return "Invalid town ID"
        case .townNotFound:
            return "Town not found"
        case .fetchFailed(let message):
            return "Error fetching details: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

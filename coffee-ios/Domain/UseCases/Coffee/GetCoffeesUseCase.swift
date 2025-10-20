//
//  GetCoffeesUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - GetCoffeesUseCase Input
struct GetCoffeesUseCaseInput {
    let townID: String?
    let farmerID: String?
    let coffeeType: Coffee.CoffeeType?
    let roastLevel: Coffee.RoastLevel?
    let searchQuery: String?
    let sortBy: CoffeeSortOption
    
    init(
        townID: String? = nil,
        farmerID: String? = nil,
        coffeeType: Coffee.CoffeeType? = nil,
        roastLevel: Coffee.RoastLevel? = nil,
        searchQuery: String? = nil,
        sortBy: CoffeeSortOption = .rating
    ) {
        self.townID = townID
        self.farmerID = farmerID
        self.coffeeType = coffeeType
        self.roastLevel = roastLevel
        self.searchQuery = searchQuery
        self.sortBy = sortBy
    }
}

enum CoffeeSortOption {
    case rating
    case price
    case name
    case newest
}

// MARK: - GetCoffeesUseCase Output
struct GetCoffeesUseCaseOutput {
    let coffees: [Coffee]
    let totalCount: Int
}

// MARK: - GetCoffeesUseCase Protocol
protocol GetCoffeesUseCaseProtocol {
    /// Gets coffees with filtering options
    /// - Parameter input: Filtering and sorting options
    /// - Returns: Coffees list and total count
    func execute(input: GetCoffeesUseCaseInput) async throws -> GetCoffeesUseCaseOutput
}

// MARK: - GetCoffeesUseCase Implementation
class GetCoffeesUseCase: GetCoffeesUseCaseProtocol {
    private let coffeeRepository: ICoffeeRepository
    
    init(coffeeRepository: ICoffeeRepository) {
        self.coffeeRepository = coffeeRepository
    }
    
    func execute(input: GetCoffeesUseCaseInput) async throws -> GetCoffeesUseCaseOutput {
        var coffees: [Coffee] = []
        
        // Fetch coffees according to filters
        if let searchQuery = input.searchQuery, !searchQuery.isEmpty {
            coffees = try await coffeeRepository.searchCoffees(query: searchQuery)
        } else if let townID = input.townID, !townID.isEmpty {
            coffees = try await coffeeRepository.fetchCoffees(byTownID: townID)
        } else if let farmerID = input.farmerID, !farmerID.isEmpty {
            coffees = try await coffeeRepository.fetchCoffees(byFarmerID: farmerID)
        } else if let coffeeType = input.coffeeType {
            coffees = try await coffeeRepository.fetchCoffees(byType: coffeeType)
        } else if let roastLevel = input.roastLevel {
            coffees = try await coffeeRepository.fetchCoffees(byRoastLevel: roastLevel)
        } else {
            coffees = try await coffeeRepository.fetchAllCoffees()
        }
        
        // Apply sorting
        coffees = sortCoffees(coffees, by: input.sortBy)
        
        Logger.shared.info("✅ Fetched \(coffees.count) coffees")
        
        return GetCoffeesUseCaseOutput(
            coffees: coffees,
            totalCount: coffees.count
        )
    }
    
    private func sortCoffees(_ coffees: [Coffee], by option: CoffeeSortOption) -> [Coffee] {
        switch option {
        case .rating:
            return coffees.sorted { (coffee1: Coffee, coffee2: Coffee) in
                coffee1.rating > coffee2.rating
            }
        case .price:
            return coffees.sorted { (coffee1: Coffee, coffee2: Coffee) in
                coffee1.pricePerUnit < coffee2.pricePerUnit
            }
        case .name:
            return coffees.sorted { (coffee1: Coffee, coffee2: Coffee) in
                coffee1.name < coffee2.name
            }
        case .newest:
            return coffees.sorted { (coffee1: Coffee, coffee2: Coffee) in
                coffee1.createdDate > coffee2.createdDate
            }
        }
    }
}

// MARK: - GetCoffeesUseCase Errors
enum GetCoffeesUseCaseError: LocalizedError {
    case fetchFailed(String)
    case noCoffeesAvailable
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Error fetching coffees: \(message)"
        case .noCoffeesAvailable:
            return "No coffees available"
        case .unknownError(let message):
            return message
        }
    }
}

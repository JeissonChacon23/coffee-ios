//
//  GetTownsUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - GetTownsUseCase Input
struct GetTownsUseCaseInput {
    let department: String?
    let searchQuery: String?
    let sortBy: TownSortOption
    
    init(
        department: String? = nil,
        searchQuery: String? = nil,
        sortBy: TownSortOption = .name
    ) {
        self.department = department
        self.searchQuery = searchQuery
        self.sortBy = sortBy
    }
}

enum TownSortOption {
    case name
    case coffeeCount
    case farmerCount
}

// MARK: - GetTownsUseCase Output
struct GetTownsUseCaseOutput {
    let towns: [Town]
    let totalCount: Int
}

// MARK: - GetTownsUseCase Protocol
protocol GetTownsUseCaseProtocol {
    /// Gets towns with filtering options
    /// - Parameter input: Filtering and sorting options
    /// - Returns: Towns list and total count
    func execute(input: GetTownsUseCaseInput) async throws -> GetTownsUseCaseOutput
}

// MARK: - GetTownsUseCase Implementation
class GetTownsUseCase: GetTownsUseCaseProtocol {
    private let townRepository: ITownRepository
    
    init(townRepository: ITownRepository) {
        self.townRepository = townRepository
    }
    
    func execute(input: GetTownsUseCaseInput) async throws -> GetTownsUseCaseOutput {
        var towns: [Town] = []
        
        // Fetch towns according to filters
        if let searchQuery = input.searchQuery, !searchQuery.isEmpty {
            towns = try await townRepository.searchTowns(query: searchQuery)
        } else if let department = input.department, !department.isEmpty {
            towns = try await townRepository.fetchTowns(byDepartment: department)
        } else {
            towns = try await townRepository.fetchAllTowns()
        }
        
        // Apply sorting
        towns = sortTowns(towns, by: input.sortBy)
        
        Logger.shared.info("✅ Fetched \(towns.count) towns")
        
        return GetTownsUseCaseOutput(
            towns: towns,
            totalCount: towns.count
        )
    }
    
    private func sortTowns(_ towns: [Town], by option: TownSortOption) -> [Town] {
        switch option {
        case .name:
            return towns.sorted { $0.name < $1.name }
        case .coffeeCount:
            return towns.sorted { $0.coffeeCount > $1.coffeeCount }
        case .farmerCount:
            return towns.sorted { $0.farmerCount > $1.farmerCount }
        }
    }
}

// MARK: - GetTownsUseCase Errors
enum GetTownsUseCaseError: LocalizedError {
    case fetchFailed(String)
    case noTownsAvailable
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Error fetching towns: \(message)"
        case .noTownsAvailable:
            return "No towns available at this time"
        case .unknownError(let message):
            return message
        }
    }
}

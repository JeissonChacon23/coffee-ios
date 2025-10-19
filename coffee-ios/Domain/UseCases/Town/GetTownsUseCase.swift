//
//  GetTownsUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - GetTownsUseCase Input
struct GetTownsUseCaseInput {
    let departamento: String?
    let searchQuery: String?
    let sortBy: TownSortOption
    
    init(
        departamento: String? = nil,
        searchQuery: String? = nil,
        sortBy: TownSortOption = .name
    ) {
        self.departamento = departamento
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
    /// Obtiene los towns con opciones de filtrado
    /// - Parameter input: Opciones de filtrado y ordenamiento
    /// - Returns: Lista de towns y cantidad total
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
        
        // Obtener towns según los filtros
        if let searchQuery = input.searchQuery, !searchQuery.isEmpty {
            towns = try await townRepository.searchTowns(query: searchQuery)
        } else if let departamento = input.departamento, !departamento.isEmpty {
            towns = try await townRepository.fetchTowns(byDepartamento: departamento)
        } else {
            towns = try await townRepository.fetchAllTowns()
        }
        
        // Aplicar ordenamiento
        towns = sortTowns(towns, by: input.sortBy)
        
        Logger.shared.info("✅ Se obtuvieron \(towns.count) towns")
        
        return GetTownsUseCaseOutput(
            towns: towns,
            totalCount: towns.count
        )
    }
    
    private func sortTowns(_ towns: [Town], by option: TownSortOption) -> [Town] {
        switch option {
        case .name:
            return towns.sorted { $0.nombre < $1.nombre }
        case .coffeeCount:
            return towns.sorted { $0.cafeCount > $1.cafeCount }
        case .farmerCount:
            return towns.sorted { $0.caficultoresCount > $1.caficultoresCount }
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
            return "Error al obtener towns: \(message)"
        case .noTownsAvailable:
            return "No hay towns disponibles en este momento"
        case .unknownError(let message):
            return message
        }
    }
}

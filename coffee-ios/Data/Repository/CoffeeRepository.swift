//
//  CoffeeRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

// MARK: - CoffeeRepository Implementation
class CoffeeRepository: ICoffeeRepository {
    private let dataSource: FirebaseCoffeeDataSourceProtocol
    private let mapper: CoffeeMapper
    private let coffeesSubject = PassthroughSubject<[Coffee], Never>()
    
    init(
        dataSource: FirebaseCoffeeDataSourceProtocol,
        mapper: CoffeeMapper = CoffeeMapper()
    ) {
        self.dataSource = dataSource
        self.mapper = mapper
    }
    
    var coffeesPublisher: AnyPublisher<[Coffee], Never> {
        coffeesSubject.eraseToAnyPublisher()
    }
    
    func fetchAllCoffees() async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchAllCoffees()
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        coffeesSubject.send(coffees)
        return coffees
    }
    
    func fetchCoffee(byID id: String) async throws -> Coffee {
        let coffeeDTO = try await dataSource.fetchCoffee(byID: id)
        return mapper.mapToDomain(coffeeDTO)
    }
    
    func fetchCoffees(byTownID townID: String) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchCoffees(byTownID: townID)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func fetchCoffees(byFarmerID farmerID: String) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchCoffees(byFarmerID: farmerID)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func fetchCoffees(byType type: Coffee.CoffeeType) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchCoffees(byType: type.rawValue)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func fetchCoffees(byRoastLevel roastLevel: Coffee.RoastLevel) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchCoffees(byRoastLevel: roastLevel.rawValue)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func searchCoffees(query: String) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.searchCoffees(query: query)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func fetchTopRatedCoffees(limit: Int) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchTopRatedCoffees(limit: limit)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func fetchMostPopularCoffees(limit: Int) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchMostPopularCoffees(limit: limit)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func addToFavorites(coffeeID: String, userID: String) async throws {
        try await dataSource.addToFavorites(coffeeID: coffeeID, userID: userID)
        Logger.shared.info("✅ Coffee added to favorites")
    }
    
    func removeFromFavorites(coffeeID: String, userID: String) async throws {
        try await dataSource.removeFromFavorites(coffeeID: coffeeID, userID: userID)
        Logger.shared.info("✅ Coffee removed from favorites")
    }
    
    func fetchFavoriteCoffees(userID: String) async throws -> [Coffee] {
        let coffeeDTOs = try await dataSource.fetchFavoriteCoffees(userID: userID)
        let coffees = coffeeDTOs.map { mapper.mapToDomain($0) }
        return coffees
    }
    
    func isFavorite(coffeeID: String, userID: String) async throws -> Bool {
        return try await dataSource.isFavorite(coffeeID: coffeeID, userID: userID)
    }
    
    func getCoffeeUpdates(coffeeID id: String) -> AnyPublisher<Coffee, Never> {
        // For now, return a simple publisher that completes immediately
        // This can be enhanced with real-time listeners later
        return Just(Coffee.preview)
            .eraseToAnyPublisher()
    }
}

//
//  TownRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

// MARK: - TownRepository Implementation
class TownRepository: ITownRepository {
    private let dataSource: FirebaseTownDataSourceProtocol
    private let mapper: TownMapper
    private let townsSubject = PassthroughSubject<[Town], Never>()
    
    init(
        dataSource: FirebaseTownDataSourceProtocol,
        mapper: TownMapper = TownMapper()
    ) {
        self.dataSource = dataSource
        self.mapper = mapper
    }
    
    var townsPublisher: AnyPublisher<[Town], Never> {
        townsSubject.eraseToAnyPublisher()
    }
    
    func fetchAllTowns() async throws -> [Town] {
        let townDTOs = try await dataSource.fetchAllTowns()
        let towns = townDTOs.map { mapper.mapToDomain($0) }
        townsSubject.send(towns)
        return towns
    }
    
    func fetchTown(byID id: String) async throws -> Town {
        let townDTO = try await dataSource.fetchTown(byID: id)
        return mapper.mapToDomain(townDTO)
    }
    
    func fetchTowns(byDepartment department: String) async throws -> [Town] {
        let townDTOs = try await dataSource.fetchTowns(byDepartment: department)
        let towns = townDTOs.map { mapper.mapToDomain($0) }
        townsSubject.send(towns)
        return towns
    }
    
    func searchTowns(query: String) async throws -> [Town] {
        let townDTOs = try await dataSource.searchTowns(query: query)
        let towns = townDTOs.map { mapper.mapToDomain($0) }
        return towns
    }
    
    func fetchTopTownsByCoffeeCount(limit: Int) async throws -> [Town] {
        let townDTOs = try await dataSource.fetchTopTownsByCoffeeCount(limit: limit)
        let towns = townDTOs.map { mapper.mapToDomain($0) }
        return towns
    }
    
    func fetchTopTownsByFarmerCount(limit: Int) async throws -> [Town] {
        let townDTOs = try await dataSource.fetchTopTownsByFarmerCount(limit: limit)
        let towns = townDTOs.map { mapper.mapToDomain($0) }
        return towns
    }
    
    func getTownUpdates(townID id: String) -> AnyPublisher<Town, Never> {
        // For now, return a simple publisher that completes immediately
        // This can be enhanced with real-time listeners later
        return Just(Town.preview)
            .eraseToAnyPublisher()
    }
}

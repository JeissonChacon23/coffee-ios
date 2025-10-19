//
//  CoffeeFarmerRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

// MARK: - CoffeeFarmerRepository Implementation
class CoffeeFarmerRepository: ICoffeeFarmerRepository {
    private let dataSource: FirebaseCoffeeFarmerDataSourceProtocol
    private let mapper: CoffeeFarmerMapper
    private let farmersSubject = PassthroughSubject<[CoffeeFarmer], Never>()
    
    init(
        dataSource: FirebaseCoffeeFarmerDataSourceProtocol,
        mapper: CoffeeFarmerMapper = CoffeeFarmerMapper()
    ) {
        self.dataSource = dataSource
        self.mapper = mapper
    }
    
    var approvedFarmersPublisher: AnyPublisher<[CoffeeFarmer], Never> {
        farmersSubject.eraseToAnyPublisher()
    }
    
    func fetchAllCoffeeFarmers() async throws -> [CoffeeFarmer] {
        let farmerDTOs = try await dataSource.fetchAllCoffeeFarmers()
        let farmers = farmerDTOs.map { mapper.mapToDomain($0) }
        farmersSubject.send(farmers)
        return farmers
    }
    
    func fetchCoffeeFarmer(byID id: String) async throws -> CoffeeFarmer {
        let farmerDTO = try await dataSource.fetchCoffeeFarmer(byID: id)
        return mapper.mapToDomain(farmerDTO)
    }
    
    func fetchCoffeeFarmers(byTownID townID: String) async throws -> [CoffeeFarmer] {
        let farmerDTOs = try await dataSource.fetchCoffeeFarmers(byTownID: townID)
        let farmers = farmerDTOs.map { mapper.mapToDomain($0) }
        return farmers
    }
    
    func fetchCoffeeFarmer(byUserID userID: String) async throws -> CoffeeFarmer? {
        guard let farmerDTO = try await dataSource.fetchCoffeeFarmer(byUserID: userID) else {
            return nil
        }
        return mapper.mapToDomain(farmerDTO)
    }
    
    func fetchCoffeeFarmers(byStatus status: CoffeeFarmer.FarmerStatus) async throws -> [CoffeeFarmer] {
        let farmerDTOs = try await dataSource.fetchCoffeeFarmers(byStatus: status.rawValue)
        let farmers = farmerDTOs.map { mapper.mapToDomain($0) }
        return farmers
    }
    
    func searchCoffeeFarmers(query: String) async throws -> [CoffeeFarmer] {
        let farmerDTOs = try await dataSource.searchCoffeeFarmers(query: query)
        let farmers = farmerDTOs.map { mapper.mapToDomain($0) }
        return farmers
    }
    
    func fetchTopRatedFarmers(limit: Int) async throws -> [CoffeeFarmer] {
        let farmerDTOs = try await dataSource.fetchTopRatedFarmers(limit: limit)
        let farmers = farmerDTOs.map { mapper.mapToDomain($0) }
        return farmers
    }
    
    func submitFarmerApplication(_ farmer: CoffeeFarmer) async throws -> CoffeeFarmer {
        let farmerDTO = mapper.mapToDTO(farmer)
        let resultDTO = try await dataSource.submitFarmerApplication(farmerDTO)
        return mapper.mapToDomain(resultDTO)
    }
    
    func updateFarmerProfile(_ farmer: CoffeeFarmer) async throws {
        let farmerDTO = mapper.mapToDTO(farmer)
        try await dataSource.updateFarmerProfile(farmerDTO)
    }
    
    func getFarmerApplicationStatus(farmerID: String) async throws -> CoffeeFarmer.FarmerStatus {
        let statusString = try await dataSource.getFarmerApplicationStatus(farmerID: farmerID)
        return CoffeeFarmer.FarmerStatus(rawValue: statusString) ?? .pending
    }
    
    func fetchPendingFarmersForVerification() async throws -> [CoffeeFarmer] {
        let farmerDTOs = try await dataSource.fetchPendingFarmersForVerification()
        let farmers = farmerDTOs.map { mapper.mapToDomain($0) }
        return farmers
    }
    
    func approveFarmerApplication(farmerID: String) async throws {
        try await dataSource.approveFarmerApplication(farmerID: farmerID)
    }
    
    func rejectFarmerApplication(farmerID: String, reason: String) async throws {
        try await dataSource.rejectFarmerApplication(farmerID: farmerID, reason: reason)
    }
    
    func getFarmerUpdates(farmerID id: String) -> AnyPublisher<CoffeeFarmer, Never> {
        return Just(CoffeeFarmer.preview)
            .eraseToAnyPublisher()
    }
}

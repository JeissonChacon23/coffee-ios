//
//  FirebaseTownDataSource.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import FirebaseFirestore

// MARK: - FirebaseTownDataSource Protocol
protocol FirebaseTownDataSourceProtocol {
    func fetchAllTowns() async throws -> [TownDTO]
    func fetchTown(byID id: String) async throws -> TownDTO
    func fetchTowns(byDepartment department: String) async throws -> [TownDTO]
    func searchTowns(query: String) async throws -> [TownDTO]
    func fetchTopTownsByCoffeeCount(limit: Int) async throws -> [TownDTO]
    func fetchTopTownsByFarmerCount(limit: Int) async throws -> [TownDTO]
}

// MARK: - FirebaseTownDataSource Implementation
class FirebaseTownDataSource: FirebaseTownDataSourceProtocol {
    private let db = Firestore.firestore()
    
    func fetchAllTowns() async throws -> [TownDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.towns)
            .whereField("isActive", isEqualTo: true)
            .order(by: "name")
            .getDocuments()
        
        let towns = try snapshot.documents.map { document in
            try document.data(as: TownDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(towns.count) towns")
        return towns
    }
    
    func fetchTown(byID id: String) async throws -> TownDTO {
        let document = try await db.collection(AppConstants.FirebaseCollections.towns)
            .document(id)
            .getDocument()
        
        guard let town = try document.data(as: TownDTO?.self) else {
            throw TownDataSourceError.townNotFound
        }
        
        Logger.shared.info("✅ Town fetched: \(town.name)")
        return town
    }
    
    func fetchTowns(byDepartment department: String) async throws -> [TownDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.towns)
            .whereField("department", isEqualTo: department)
            .whereField("isActive", isEqualTo: true)
            .order(by: "name")
            .getDocuments()
        
        let towns = try snapshot.documents.map { document in
            try document.data(as: TownDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(towns.count) towns in department: \(department)")
        return towns
    }
    
    func searchTowns(query: String) async throws -> [TownDTO] {
        let lowerQuery = query.lowercased()
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.towns)
            .whereField("isActive", isEqualTo: true)
            .getDocuments()
        
        let towns = try snapshot.documents
            .compactMap { document -> TownDTO? in
                let town = try document.data(as: TownDTO.self)
                if town.name.lowercased().contains(lowerQuery) ||
                   town.description.lowercased().contains(lowerQuery) {
                    return town
                }
                return nil
            }
            .sorted { $0.name < $1.name }
        
        Logger.shared.info("✅ Search found \(towns.count) towns matching: \(query)")
        return towns
    }
    
    func fetchTopTownsByCoffeeCount(limit: Int) async throws -> [TownDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.towns)
            .whereField("isActive", isEqualTo: true)
            .order(by: "coffeeCount", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        let towns = try snapshot.documents.map { document in
            try document.data(as: TownDTO.self)
        }
        
        Logger.shared.info("✅ Fetched top \(towns.count) towns by coffee count")
        return towns
    }
    
    func fetchTopTownsByFarmerCount(limit: Int) async throws -> [TownDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.towns)
            .whereField("isActive", isEqualTo: true)
            .order(by: "farmerCount", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        let towns = try snapshot.documents.map { document in
            try document.data(as: TownDTO.self)
        }
        
        Logger.shared.info("✅ Fetched top \(towns.count) towns by farmer count")
        return towns
    }
}

// MARK: - TownDataSourceError
enum TownDataSourceError: LocalizedError {
    case townNotFound
    case fetchFailed(String)
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .townNotFound:
            return "Town not found"
        case .fetchFailed(let message):
            return "Error fetching towns: \(message)"
        case .invalidData:
            return "Invalid town data"
        }
    }
}

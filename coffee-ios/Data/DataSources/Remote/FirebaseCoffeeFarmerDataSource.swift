//
//  FirebaseCoffeeFarmerDataSource.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import FirebaseFirestore

// MARK: - FirebaseCoffeeFarmerDataSource Protocol
protocol FirebaseCoffeeFarmerDataSourceProtocol {
    func fetchAllCoffeeFarmers() async throws -> [CoffeeFarmerDTO]
    func fetchCoffeeFarmer(byID id: String) async throws -> CoffeeFarmerDTO
    func fetchCoffeeFarmers(byTownID townID: String) async throws -> [CoffeeFarmerDTO]
    func fetchCoffeeFarmer(byUserID userID: String) async throws -> CoffeeFarmerDTO?
    func fetchCoffeeFarmers(byStatus status: String) async throws -> [CoffeeFarmerDTO]
    func searchCoffeeFarmers(query: String) async throws -> [CoffeeFarmerDTO]
    func fetchTopRatedFarmers(limit: Int) async throws -> [CoffeeFarmerDTO]
    func submitFarmerApplication(_ farmerDTO: CoffeeFarmerDTO) async throws -> CoffeeFarmerDTO
    func updateFarmerProfile(_ farmerDTO: CoffeeFarmerDTO) async throws
    func getFarmerApplicationStatus(farmerID: String) async throws -> String
    func fetchPendingFarmersForVerification() async throws -> [CoffeeFarmerDTO]
    func approveFarmerApplication(farmerID: String) async throws
    func rejectFarmerApplication(farmerID: String, reason: String) async throws
}

// MARK: - FirebaseCoffeeFarmerDataSource Implementation
class FirebaseCoffeeFarmerDataSource: FirebaseCoffeeFarmerDataSourceProtocol {
    private let db = Firestore.firestore()
    
    func fetchAllCoffeeFarmers() async throws -> [CoffeeFarmerDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .whereField("status", isEqualTo: "Approved")
            .order(by: "rating", descending: true)
            .getDocuments()
        
        let farmers = try snapshot.documents.map { document in
            try document.data(as: CoffeeFarmerDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(farmers.count) coffee farmers")
        return farmers
    }
    
    func fetchCoffeeFarmer(byID id: String) async throws -> CoffeeFarmerDTO {
        let document = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .document(id)
            .getDocument()
        
        guard let farmer = try document.data(as: CoffeeFarmerDTO?.self) else {
            throw CoffeeFarmerDataSourceError.farmerNotFound
        }
        
        Logger.shared.info("✅ Coffee farmer fetched: \(farmer.farmName)")
        return farmer
    }
    
    func fetchCoffeeFarmers(byTownID townID: String) async throws -> [CoffeeFarmerDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .whereField("townID", isEqualTo: townID)
            .whereField("status", isEqualTo: "Approved")
            .order(by: "rating", descending: true)
            .getDocuments()
        
        let farmers = try snapshot.documents.map { document in
            try document.data(as: CoffeeFarmerDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(farmers.count) farmers for town: \(townID)")
        return farmers
    }
    
    func fetchCoffeeFarmer(byUserID userID: String) async throws -> CoffeeFarmerDTO? {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .whereField("userID", isEqualTo: userID)
            .getDocuments()
        
        guard let document = snapshot.documents.first else {
            return nil
        }
        
        return try document.data(as: CoffeeFarmerDTO.self)
    }
    
    func fetchCoffeeFarmers(byStatus status: String) async throws -> [CoffeeFarmerDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .whereField("status", isEqualTo: status)
            .order(by: "applicationDate", descending: true)
            .getDocuments()
        
        let farmers = try snapshot.documents.map { document in
            try document.data(as: CoffeeFarmerDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(farmers.count) farmers with status: \(status)")
        return farmers
    }
    
    func searchCoffeeFarmers(query: String) async throws -> [CoffeeFarmerDTO] {
        let lowerQuery = query.lowercased()
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .whereField("status", isEqualTo: "Approved")
            .getDocuments()
        
        let farmers = try snapshot.documents
            .compactMap { document -> CoffeeFarmerDTO? in
                let farmer = try document.data(as: CoffeeFarmerDTO.self)
                if farmer.farmName.lowercased().contains(lowerQuery) ||
                   farmer.farmDescription.lowercased().contains(lowerQuery) {
                    return farmer
                }
                return nil
            }
            .sorted { $0.rating > $1.rating }
        
        Logger.shared.info("✅ Search found \(farmers.count) farmers matching: \(query)")
        return farmers
    }
    
    func fetchTopRatedFarmers(limit: Int) async throws -> [CoffeeFarmerDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .whereField("status", isEqualTo: "Approved")
            .order(by: "rating", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        let farmers = try snapshot.documents.map { document in
            try document.data(as: CoffeeFarmerDTO.self)
        }
        
        Logger.shared.info("✅ Fetched top \(farmers.count) rated farmers")
        return farmers
    }
    
    func submitFarmerApplication(_ farmerDTO: CoffeeFarmerDTO) async throws -> CoffeeFarmerDTO {
        try db.collection(AppConstants.FirebaseCollections.caficultores)
            .document(farmerDTO.id)
            .setData(from: farmerDTO)
        
        Logger.shared.info("✅ Farmer application submitted: \(farmerDTO.farmName)")
        return farmerDTO
    }
    
    func updateFarmerProfile(_ farmerDTO: CoffeeFarmerDTO) async throws {
        try db.collection(AppConstants.FirebaseCollections.caficultores)
            .document(farmerDTO.id)
            .setData(from: farmerDTO, merge: true)
        
        Logger.shared.info("✅ Farmer profile updated: \(farmerDTO.id)")
    }
    
    func getFarmerApplicationStatus(farmerID: String) async throws -> String {
        let document = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .document(farmerID)
            .getDocument()
        
        guard let farmer = try document.data(as: CoffeeFarmerDTO?.self) else {
            throw CoffeeFarmerDataSourceError.farmerNotFound
        }
        
        return farmer.status
    }
    
    func fetchPendingFarmersForVerification() async throws -> [CoffeeFarmerDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .whereField("status", isEqualTo: "Pending")
            .order(by: "applicationDate", descending: true)
            .getDocuments()
        
        let farmers = try snapshot.documents.map { document in
            try document.data(as: CoffeeFarmerDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(farmers.count) pending farmers for verification")
        return farmers
    }
    
    func approveFarmerApplication(farmerID: String) async throws {
        try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .document(farmerID)
            .updateData([
                "status": "Approved",
                "verificationDate": Date(),
                "isVerified": true
            ])
        
        Logger.shared.info("✅ Farmer application approved: \(farmerID)")
    }
    
    func rejectFarmerApplication(farmerID: String, reason: String) async throws {
        try await db.collection(AppConstants.FirebaseCollections.caficultores)
            .document(farmerID)
            .updateData([
                "status": "Rejected",
                "verificationDate": Date()
            ])
        
        Logger.shared.info("✅ Farmer application rejected: \(farmerID)")
    }
}

// MARK: - CoffeeFarmerDataSourceError
enum CoffeeFarmerDataSourceError: LocalizedError {
    case farmerNotFound
    case fetchFailed(String)
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .farmerNotFound:
            return "Coffee farmer not found"
        case .fetchFailed(let message):
            return "Error fetching farmers: \(message)"
        case .invalidData:
            return "Invalid farmer data"
        }
    }
}

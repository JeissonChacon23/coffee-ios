//
//  FirebaseCoffeeDataSource.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import FirebaseFirestore

// MARK: - FirebaseCoffeeDataSource Protocol
protocol FirebaseCoffeeDataSourceProtocol {
    func fetchAllCoffees() async throws -> [CoffeeDTO]
    func fetchCoffee(byID id: String) async throws -> CoffeeDTO
    func fetchCoffees(byTownID townID: String) async throws -> [CoffeeDTO]
    func fetchCoffees(byFarmerID farmerID: String) async throws -> [CoffeeDTO]
    func fetchCoffees(byType type: String) async throws -> [CoffeeDTO]
    func fetchCoffees(byRoastLevel roastLevel: String) async throws -> [CoffeeDTO]
    func searchCoffees(query: String) async throws -> [CoffeeDTO]
    func fetchTopRatedCoffees(limit: Int) async throws -> [CoffeeDTO]
    func fetchMostPopularCoffees(limit: Int) async throws -> [CoffeeDTO]
    func addToFavorites(coffeeID: String, userID: String) async throws
    func removeFromFavorites(coffeeID: String, userID: String) async throws
    func fetchFavoriteCoffees(userID: String) async throws -> [CoffeeDTO]
    func isFavorite(coffeeID: String, userID: String) async throws -> Bool
}

// MARK: - FirebaseCoffeeDataSource Implementation
class FirebaseCoffeeDataSource: FirebaseCoffeeDataSourceProtocol {
    private let db = Firestore.firestore()
    
    func fetchAllCoffees() async throws -> [CoffeeDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .order(by: "rating", descending: true)
            .getDocuments()
        
        let coffees = try snapshot.documents.map { document in
            try document.data(as: CoffeeDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(coffees.count) coffees")
        return coffees
    }
    
    func fetchCoffee(byID id: String) async throws -> CoffeeDTO {
        let document = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .document(id)
            .getDocument()
        
        guard let coffee = try document.data(as: CoffeeDTO?.self) else {
            throw CoffeeDataSourceError.coffeeNotFound
        }
        
        Logger.shared.info("✅ Coffee fetched: \(coffee.name)")
        return coffee
    }
    
    func fetchCoffees(byTownID townID: String) async throws -> [CoffeeDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .whereField("townID", isEqualTo: townID)
            .order(by: "rating", descending: true)
            .getDocuments()
        
        let coffees = try snapshot.documents.map { document in
            try document.data(as: CoffeeDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(coffees.count) coffees for town: \(townID)")
        return coffees
    }
    
    func fetchCoffees(byFarmerID farmerID: String) async throws -> [CoffeeDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .whereField("farmerID", isEqualTo: farmerID)
            .order(by: "rating", descending: true)
            .getDocuments()
        
        let coffees = try snapshot.documents.map { document in
            try document.data(as: CoffeeDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(coffees.count) coffees for farmer: \(farmerID)")
        return coffees
    }
    
    func fetchCoffees(byType type: String) async throws -> [CoffeeDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .whereField("type", isEqualTo: type)
            .order(by: "rating", descending: true)
            .getDocuments()
        
        let coffees = try snapshot.documents.map { document in
            try document.data(as: CoffeeDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(coffees.count) coffees of type: \(type)")
        return coffees
    }
    
    func fetchCoffees(byRoastLevel roastLevel: String) async throws -> [CoffeeDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .whereField("roastLevel", isEqualTo: roastLevel)
            .order(by: "rating", descending: true)
            .getDocuments()
        
        let coffees = try snapshot.documents.map { document in
            try document.data(as: CoffeeDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(coffees.count) coffees with roast level: \(roastLevel)")
        return coffees
    }
    
    func searchCoffees(query: String) async throws -> [CoffeeDTO] {
        let lowerQuery = query.lowercased()
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .getDocuments()
        
        let coffees = try snapshot.documents
            .compactMap { document -> CoffeeDTO? in
                let coffee = try document.data(as: CoffeeDTO.self)
                if coffee.name.lowercased().contains(lowerQuery) ||
                   coffee.description.lowercased().contains(lowerQuery) {
                    return coffee
                }
                return nil
            }
            .sorted { $0.rating > $1.rating }
        
        Logger.shared.info("✅ Search found \(coffees.count) coffees matching: \(query)")
        return coffees
    }
    
    func fetchTopRatedCoffees(limit: Int) async throws -> [CoffeeDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .order(by: "rating", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        let coffees = try snapshot.documents.map { document in
            try document.data(as: CoffeeDTO.self)
        }
        
        Logger.shared.info("✅ Fetched top \(coffees.count) rated coffees")
        return coffees
    }
    
    func fetchMostPopularCoffees(limit: Int) async throws -> [CoffeeDTO] {
        let snapshot = try await db.collection(AppConstants.FirebaseCollections.coffees)
            .order(by: "rating", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        let coffees = try snapshot.documents.map { document in
            try document.data(as: CoffeeDTO.self)
        }
        
        Logger.shared.info("✅ Fetched \(coffees.count) most popular coffees")
        return coffees
    }
    
    func addToFavorites(coffeeID: String, userID: String) async throws {
        try await db.collection(AppConstants.FirebaseCollections.users)
            .document(userID)
            .collection("favorites")
            .document(coffeeID)
            .setData(["addedDate": Date()])
        
        Logger.shared.info("✅ Coffee added to favorites: \(coffeeID)")
    }
    
    func removeFromFavorites(coffeeID: String, userID: String) async throws {
        try await db.collection(AppConstants.FirebaseCollections.users)
            .document(userID)
            .collection("favorites")
            .document(coffeeID)
            .delete()
        
        Logger.shared.info("✅ Coffee removed from favorites: \(coffeeID)")
    }
    
    func fetchFavoriteCoffees(userID: String) async throws -> [CoffeeDTO] {
        let favoriteIDs = try await db.collection(AppConstants.FirebaseCollections.users)
            .document(userID)
            .collection("favorites")
            .getDocuments()
            .documents
            .map { $0.documentID }
        
        var favoriteCoffees: [CoffeeDTO] = []
        for coffeeID in favoriteIDs {
            let coffee = try await fetchCoffee(byID: coffeeID)
            favoriteCoffees.append(coffee)
        }
        
        Logger.shared.info("✅ Fetched \(favoriteCoffees.count) favorite coffees")
        return favoriteCoffees
    }
    
    func isFavorite(coffeeID: String, userID: String) async throws -> Bool {
        let document = try await db.collection(AppConstants.FirebaseCollections.users)
            .document(userID)
            .collection("favorites")
            .document(coffeeID)
            .getDocument()
        
        return document.exists
    }
}

// MARK: - CoffeeDataSourceError
enum CoffeeDataSourceError: LocalizedError {
    case coffeeNotFound
    case fetchFailed(String)
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .coffeeNotFound:
            return "Coffee not found"
        case .fetchFailed(let message):
            return "Error fetching coffees: \(message)"
        case .invalidData:
            return "Invalid coffee data"
        }
    }
}

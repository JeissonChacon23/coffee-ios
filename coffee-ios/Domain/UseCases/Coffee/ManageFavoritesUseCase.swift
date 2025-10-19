//
//  ManageFavoritesUseCase.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - ManageFavoritesUseCase Input
struct ManageFavoritesUseCaseInput {
    let action: FavoriteAction
    let coffeeID: String
    let userID: String
}

enum FavoriteAction {
    case add
    case remove
    case toggle
    case isFavorite
}

// MARK: - ManageFavoritesUseCase Output
struct ManageFavoritesUseCaseOutput {
    let action: FavoriteAction
    let isFavorite: Bool
    let message: String
}

// MARK: - ManageFavoritesUseCase Protocol
protocol ManageFavoritesUseCaseProtocol {
    /// Manages favorite coffee actions
    /// - Parameter input: Action to perform, coffee ID and user ID
    /// - Returns: Action result
    func execute(input: ManageFavoritesUseCaseInput) async throws -> ManageFavoritesUseCaseOutput
}

// MARK: - ManageFavoritesUseCase Implementation
class ManageFavoritesUseCase: ManageFavoritesUseCaseProtocol {
    private let coffeeRepository: ICoffeeRepository
    
    init(coffeeRepository: ICoffeeRepository) {
        self.coffeeRepository = coffeeRepository
    }
    
    func execute(input: ManageFavoritesUseCaseInput) async throws -> ManageFavoritesUseCaseOutput {
        // Validate IDs
        guard !input.coffeeID.isEmpty else {
            throw ManageFavoritesUseCaseError.invalidCoffeeID
        }
        
        guard !input.userID.isEmpty else {
            throw ManageFavoritesUseCaseError.invalidUserID
        }
        
        var isFavorite = false
        var message = ""
        
        switch input.action {
        case .add:
            try await coffeeRepository.addToFavorites(
                coffeeID: input.coffeeID,
                userID: input.userID
            )
            isFavorite = true
            message = "Coffee added to favorites ❤️"
            Logger.shared.info("⭐ Coffee added to favorites: \(input.coffeeID)")
            
        case .remove:
            try await coffeeRepository.removeFromFavorites(
                coffeeID: input.coffeeID,
                userID: input.userID
            )
            isFavorite = false
            message = "Coffee removed from favorites"
            Logger.shared.info("⭐ Coffee removed from favorites: \(input.coffeeID)")
            
        case .toggle:
            let currentStatus = try await coffeeRepository.isFavorite(
                coffeeID: input.coffeeID,
                userID: input.userID
            )
            
            if currentStatus {
                try await coffeeRepository.removeFromFavorites(
                    coffeeID: input.coffeeID,
                    userID: input.userID
                )
                isFavorite = false
                message = "Coffee removed from favorites"
            } else {
                try await coffeeRepository.addToFavorites(
                    coffeeID: input.coffeeID,
                    userID: input.userID
                )
                isFavorite = true
                message = "Coffee added to favorites ❤️"
            }
            
        case .isFavorite:
            isFavorite = try await coffeeRepository.isFavorite(
                coffeeID: input.coffeeID,
                userID: input.userID
            )
            message = isFavorite ? "Is favorite" : "Not favorite"
        }
        
        return ManageFavoritesUseCaseOutput(
            action: input.action,
            isFavorite: isFavorite,
            message: message
        )
    }
}

// MARK: - ManageFavoritesUseCase Errors
enum ManageFavoritesUseCaseError: LocalizedError {
    case invalidCoffeeID
    case invalidUserID
    case operationFailed(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCoffeeID:
            return "Invalid coffee ID"
        case .invalidUserID:
            return "Invalid user ID"
        case .operationFailed(let message):
            return "Operation failed: \(message)"
        case .unknownError(let message):
            return message
        }
    }
}

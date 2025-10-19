//
//  ICoffeeRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

protocol ICoffeeRepository {
    // MARK: - Fetch Methods
    
    /// Obtiene todos los cafés disponibles
    /// - Returns: Array de cafés
    func fetchAllCoffees() async throws -> [Coffee]
    
    /// Obtiene un café por su ID
    /// - Parameter id: ID del café
    /// - Returns: El café solicitado
    func fetchCoffee(byID id: String) async throws -> Coffee
    
    /// Obtiene cafés por town
    /// - Parameter townID: ID del town
    /// - Returns: Array de cafés en ese town
    func fetchCoffees(byTownID townID: String) async throws -> [Coffee]
    
    /// Obtiene cafés por caficultor
    /// - Parameter farmerID: ID del caficultor
    /// - Returns: Array de cafés de ese caficultor
    func fetchCoffees(byFarmerID farmerID: String) async throws -> [Coffee]
    
    // MARK: - Filter Methods
    
    /// Obtiene cafés por tipo
    /// - Parameter type: Tipo de café (arabica, robusta, híbrido)
    /// - Returns: Array de cafés del tipo especificado
    func fetchCoffees(byType type: Coffee.CoffeeType) async throws -> [Coffee]
    
    /// Obtiene cafés por nivel de tostado
    /// - Parameter roastLevel: Nivel de tostado
    /// - Returns: Array de cafés con ese nivel
    func fetchCoffees(byRoastLevel roastLevel: Coffee.RoastLevel) async throws -> [Coffee]
    
    /// Busca cafés por nombre o descripción
    /// - Parameter query: Texto a buscar
    /// - Returns: Array de cafés que coinciden
    func searchCoffees(query: String) async throws -> [Coffee]
    
    // MARK: - Ranking Methods
    
    /// Obtiene los cafés mejor calificados
    /// - Parameter limit: Número máximo de resultados
    /// - Returns: Array de cafés ordenados por calificación
    func fetchTopRatedCoffees(limit: Int) async throws -> [Coffee]
    
    /// Obtiene los cafés más vendidos/populares
    /// - Parameter limit: Número máximo de resultados
    /// - Returns: Array de cafés más populares
    func fetchMostPopularCoffees(limit: Int) async throws -> [Coffee]
    
    // MARK: - Favorite Methods
    
    /// Agrega un café a favoritos
    /// - Parameter coffeeID: ID del café
    /// - Parameter userID: ID del usuario
    func addToFavorites(coffeeID: String, userID: String) async throws
    
    /// Remueve un café de favoritos
    /// - Parameter coffeeID: ID del café
    /// - Parameter userID: ID del usuario
    func removeFromFavorites(coffeeID: String, userID: String) async throws
    
    /// Obtiene los favoritos del usuario
    /// - Parameter userID: ID del usuario
    /// - Returns: Array de cafés favoritos
    func fetchFavoriteCoffees(userID: String) async throws -> [Coffee]
    
    /// Verifica si un café es favorito
    /// - Parameters:
    ///   - coffeeID: ID del café
    ///   - userID: ID del usuario
    /// - Returns: Boolean indicando si es favorito
    func isFavorite(coffeeID: String, userID: String) async throws -> Bool
    
    // MARK: - Publisher Methods
    
    /// Publisher que emite todos los cafés
    var coffeesPublisher: AnyPublisher<[Coffee], Never> { get }
    
    /// Publisher que emite cambios en un café específico
    /// - Parameter id: ID del café
    /// - Returns: Publisher con actualizaciones del café
    func getCoffeeUpdates(coffeeID id: String) -> AnyPublisher<Coffee, Never>
}

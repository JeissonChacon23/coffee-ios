//
//  IMunicipiRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

protocol ITownRepository {
    // MARK: - Fetch Methods
    
    /// Obtiene todos los towns disponibles
    /// - Returns: Array de towns
    func fetchAllTowns() async throws -> [Town]
    
    /// Obtiene un town por su ID
    /// - Parameter id: ID del town
    /// - Returns: El town solicitado
    func fetchTown(byID id: String) async throws -> Town
    
    /// Obtiene towns por departamento
    /// - Parameter departamento: Nombre del departamento
    /// - Returns: Array de towns en ese departamento
    func fetchTowns(byDepartamento departamento: String) async throws -> [Town]
    
    /// Busca towns por nombre
    /// - Parameter query: Texto a buscar
    /// - Returns: Array de towns que coinciden con la búsqueda
    func searchTowns(query: String) async throws -> [Town]
    
    // MARK: - Filter Methods
    
    /// Obtiene towns ordenados por cantidad de cafés
    /// - Parameter limit: Número máximo de resultados
    /// - Returns: Array de towns ordenados
    func fetchTopTownsByCoffeeCount(limit: Int) async throws -> [Town]
    
    /// Obtiene towns ordenados por cantidad de caficultores
    /// - Parameter limit: Número máximo de resultados
    /// - Returns: Array de towns ordenados
    func fetchTopTownsByFarmerCount(limit: Int) async throws -> [Town]
    
    // MARK: - Publisher Methods
    
    /// Publisher que emite los towns disponibles
    var townsPublisher: AnyPublisher<[Town], Never> { get }
    
    /// Publisher que emite cambios en un town específico
    /// - Parameter id: ID del town
    /// - Returns: Publisher con actualizaciones del town
    func getTownUpdates(townID id: String) -> AnyPublisher<Town, Never>
}

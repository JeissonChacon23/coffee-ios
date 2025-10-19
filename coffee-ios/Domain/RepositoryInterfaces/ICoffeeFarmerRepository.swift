//
//  ICoffeeFarmerRepository.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation
import Combine

protocol ICoffeeFarmerRepository {
    // MARK: - Fetch Methods
    
    /// Obtiene todos los caficultores
    /// - Returns: Array de caficultores
    func fetchAllCoffeeFarmers() async throws -> [CoffeeFarmer]
    
    /// Obtiene un caficultor por su ID
    /// - Parameter id: ID del caficultor
    /// - Returns: El caficultor solicitado
    func fetchCoffeeFarmer(byID id: String) async throws -> CoffeeFarmer
    
    /// Obtiene caficultores por town
    /// - Parameter townID: ID del town
    /// - Returns: Array de caficultores en ese town
    func fetchCoffeeFarmers(byTownID townID: String) async throws -> [CoffeeFarmer]
    
    /// Obtiene caficultores por userID
    /// - Parameter userID: ID del usuario
    /// - Returns: El caficultor asociado al usuario
    func fetchCoffeeFarmer(byUserID userID: String) async throws -> CoffeeFarmer?
    
    // MARK: - Filter Methods
    
    /// Obtiene caficultores por estado
    /// - Parameter status: Estado del caficultor (aprobado, pendiente, rechazado, suspendido)
    /// - Returns: Array de caficultores con ese estado
    func fetchCoffeeFarmers(byStatus status: CoffeeFarmer.FarmerStatus) async throws -> [CoffeeFarmer]
    
    /// Busca caficultores por nombre
    /// - Parameter query: Texto a buscar
    /// - Returns: Array de caficultores que coinciden
    func searchCoffeeFarmers(query: String) async throws -> [CoffeeFarmer]
    
    // MARK: - Ranking Methods
    
    /// Obtiene los caficultores mejor calificados
    /// - Parameter limit: Número máximo de resultados
    /// - Returns: Array de caficultores ordenados por calificación
    func fetchTopRatedFarmers(limit: Int) async throws -> [CoffeeFarmer]
    
    // MARK: - Application Management
    
    /// Crea una solicitud de caficultor
    /// - Parameter farmer: Datos del nuevo caficultor
    /// - Returns: El caficultor creado
    func submitFarmerApplication(_ farmer: CoffeeFarmer) async throws -> CoffeeFarmer
    
    /// Actualiza el perfil del caficultor
    /// - Parameter farmer: Datos actualizados del caficultor
    func updateFarmerProfile(_ farmer: CoffeeFarmer) async throws
    
    /// Obtiene el estado de la solicitud de un caficultor
    /// - Parameter farmerID: ID del caficultor
    /// - Returns: Estado actual de la solicitud
    func getFarmerApplicationStatus(farmerID: String) async throws -> CoffeeFarmer.FarmerStatus
    
    // MARK: - Verification Methods
    
    /// Obtiene caficultores pendientes de verificación (solo admin)
    /// - Returns: Array de caficultores pendientes
    func fetchPendingFarmersForVerification() async throws -> [CoffeeFarmer]
    
    /// Aprueba una solicitud de caficultor (solo admin)
    /// - Parameter farmerID: ID del caficultor
    func approveFarmerApplication(farmerID: String) async throws
    
    /// Rechaza una solicitud de caficultor (solo admin)
    /// - Parameters:
    ///   - farmerID: ID del caficultor
    ///   - reason: Razón del rechazo
    func rejectFarmerApplication(farmerID: String, reason: String) async throws
    
    // MARK: - Publisher Methods
    
    /// Publisher que emite todos los caficultores aprobados
    var approvedFarmersPublisher: AnyPublisher<[CoffeeFarmer], Never> { get }
    
    /// Publisher que emite cambios en un caficultor específico
    /// - Parameter id: ID del caficultor
    /// - Returns: Publisher con actualizaciones del caficultor
    func getFarmerUpdates(farmerID id: String) -> AnyPublisher<CoffeeFarmer, Never>
}

//
//  TownsListViewModel.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 19/10/25.
//

import Foundation
import Combine

// MARK: - TownsListViewModel
@MainActor
class TownsListViewModel: ObservableObject {
    @Published var towns: [Town] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedDepartment: String?
    
    private let getTownsUseCase: GetTownsUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(getTownsUseCase: GetTownsUseCaseProtocol) {
        self.getTownsUseCase = getTownsUseCase
    }
    
    // MARK: - Public Methods
    
    func fetchTowns() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let input = GetTownsUseCaseInput(
                    department: selectedDepartment,
                    searchQuery: searchText.isEmpty ? nil : searchText,
                    sortBy: .name
                )
                
                let output = try await getTownsUseCase.execute(input: input)
                self.towns = output.towns
                Logger.shared.info("✅ Fetched \(output.towns.count) towns")
            } catch {
                self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                Logger.shared.error("❌ Error fetching towns: \(error.localizedDescription)")
            }
            
            self.isLoading = false
        }
    }
    
    func fetchTopTownsByCoffeeCount(limit: Int = 5) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let input = GetTownsUseCaseInput(
                    sortBy: .coffeeCount
                )
                
                let output = try await getTownsUseCase.execute(input: input)
                self.towns = Array(output.towns.prefix(limit))
                Logger.shared.info("✅ Fetched top \(self.towns.count) towns by coffee count")
            } catch {
                self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                Logger.shared.error("❌ Error fetching top towns: \(error.localizedDescription)")
            }
            
            self.isLoading = false
        }
    }
    
    func search(query: String) {
        searchText = query
        fetchTowns()
    }
    
    func filterByDepartment(_ department: String?) {
        selectedDepartment = department
        fetchTowns()
    }
    
    func clearFilters() {
        searchText = ""
        selectedDepartment = nil
        fetchTowns()
    }
}

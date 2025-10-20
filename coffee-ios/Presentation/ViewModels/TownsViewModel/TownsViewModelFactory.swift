//
//  TownsViewModelFactory.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 19/10/25.
//

import Foundation

// MARK: - TownsViewModelFactory
class TownsViewModelFactory {
    static func makeTownsListViewModel(container: DIContainer = DIContainer.shared) -> TownsListViewModel {
        return TownsListViewModel(
            getTownsUseCase: container.makeGetTownsUseCase()
        )
    }
}

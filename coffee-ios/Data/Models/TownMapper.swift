//
//  TownMapper.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - TownMapper
class TownMapper {
    
    /// Maps Town (Domain) to TownDTO (Data)
    func mapToDTO(_ town: Town) -> TownDTO {
        return TownDTO(
            id: town.id,
            name: town.name,
            department: town.department,
            description: town.description,
            postalCode: town.postalCode,
            latitude: town.latitude,
            longitude: town.longitude,
            imageURL: town.imageURL,
            coffeeCount: town.coffeeCount,
            farmerCount: town.farmerCount,
            isActive: town.isActive,
            createdDate: town.createdDate
        )
    }
    
    /// Maps TownDTO (Data) to Town (Domain)
    func mapToDomain(_ townDTO: TownDTO) -> Town {
        return Town(
            id: townDTO.id,
            name: townDTO.name,
            department: townDTO.department,
            description: townDTO.description,
            postalCode: townDTO.postalCode,
            latitude: townDTO.latitude,
            longitude: townDTO.longitude,
            imageURL: townDTO.imageURL,
            coffeeCount: townDTO.coffeeCount,
            farmerCount: townDTO.farmerCount,
            isActive: townDTO.isActive,
            createdDate: townDTO.createdDate
        )
    }
}

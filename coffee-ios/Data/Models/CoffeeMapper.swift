//
//  CoffeeMapper.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - CoffeeMapper
class CoffeeMapper {
    
    /// Maps Coffee (Domain) to CoffeeDTO (Data)
    func mapToDTO(_ coffee: Coffee) -> CoffeeDTO {
        return CoffeeDTO(
            id: coffee.id,
            name: coffee.name,
            description: coffee.description,
            type: coffee.type.rawValue,
            roastLevel: coffee.roastLevel.rawValue,
            pricesPerPound: coffee.pricePerUnit,
            availableQuantity: coffee.availableQuantity,
            imageURL: coffee.imageURL,
            farmerID: coffee.farmerID,
            townID: coffee.townID,
            rating: coffee.rating,
            notes: coffee.notes,
            altitude: coffee.altitude,
            varieties: coffee.varieties,
            certifications: coffee.certifications,
            isFavorite: coffee.isFavorite,
            createdDate: coffee.createdDate
        )
    }
    
    /// Maps CoffeeDTO (Data) to Coffee (Domain)
    func mapToDomain(_ coffeeDTO: CoffeeDTO) -> Coffee {
        let coffeeType = Coffee.CoffeeType(rawValue: coffeeDTO.type) ?? .arabica
        let roastLevel = Coffee.RoastLevel(rawValue: coffeeDTO.roastLevel) ?? .medium
        
        return Coffee(
            id: coffeeDTO.id,
            name: coffeeDTO.name,
            description: coffeeDTO.description,
            type: coffeeType,
            roastLevel: roastLevel,
            pricePerUnit: coffeeDTO.pricesPerPound,
            availableQuantity: coffeeDTO.availableQuantity,
            imageURL: coffeeDTO.imageURL,
            farmerID: coffeeDTO.farmerID,
            townID: coffeeDTO.townID,
            rating: coffeeDTO.rating,
            notes: coffeeDTO.notes,
            altitude: coffeeDTO.altitude,
            varieties: coffeeDTO.varieties,
            certifications: coffeeDTO.certifications,
            isFavorite: coffeeDTO.isFavorite,
            createdDate: coffeeDTO.createdDate
        )
    }
}

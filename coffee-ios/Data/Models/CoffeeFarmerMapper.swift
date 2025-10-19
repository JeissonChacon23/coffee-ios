//
//  CoffeeFarmerMapper.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - CoffeeFarmerMapper
class CoffeeFarmerMapper {
    
    /// Maps CoffeeFarmer (Domain) to CoffeeFarmerDTO (Data)
    func mapToDTO(_ farmer: CoffeeFarmer) -> CoffeeFarmerDTO {
        return CoffeeFarmerDTO(
            id: farmer.id,
            userID: farmer.userID,
            farmName: farmer.name,
            farmDescription: farmer.description,
            townID: farmer.townID,
            hectares: farmer.hectares,
            altitude: farmer.altitude,
            coffeeTypes: farmer.coffeeTypes,
            certifications: farmer.certifications,
            farmImageURL: farmer.imageURL,
            latitude: farmer.latitude,
            longitude: farmer.longitude,
            status: farmer.status.rawValue,
            annualProduction: farmer.annualProduction,
            mainContact: farmer.primaryContact,
            contactPhone: farmer.primaryPhone,
            contactEmail: farmer.primaryEmail,
            experience: farmer.yearsOfExperience,
            cultivationMethods: farmer.cultivationMethods,
            rating: farmer.rating,
            productCount: farmer.productCount,
            isVerified: farmer.isVerified,
            applicationDate: farmer.applicationDate,
            verificationDate: farmer.verificationDate
        )
    }
    
    /// Maps CoffeeFarmerDTO (Data) to CoffeeFarmer (Domain)
    func mapToDomain(_ farmerDTO: CoffeeFarmerDTO) -> CoffeeFarmer {
        let status = CoffeeFarmer.FarmerStatus(rawValue: farmerDTO.status) ?? .pending
        
        return CoffeeFarmer(
            id: farmerDTO.id,
            userID: farmerDTO.userID,
            name: farmerDTO.farmName,
            description: farmerDTO.farmDescription,
            townID: farmerDTO.townID,
            hectares: farmerDTO.hectares,
            altitude: farmerDTO.altitude,
            coffeeTypes: farmerDTO.coffeeTypes,
            certifications: farmerDTO.certifications,
            imageURL: farmerDTO.farmImageURL,
            latitude: farmerDTO.latitude,
            longitude: farmerDTO.longitude,
            status: status,
            annualProduction: farmerDTO.annualProduction,
            primaryContact: farmerDTO.mainContact,
            primaryPhone: farmerDTO.contactPhone,
            primaryEmail: farmerDTO.contactEmail,
            yearsOfExperience: farmerDTO.experience,
            cultivationMethods: farmerDTO.cultivationMethods,
            rating: farmerDTO.rating,
            productCount: farmerDTO.productCount,
            isVerified: farmerDTO.isVerified,
            applicationDate: farmerDTO.applicationDate,
            verificationDate: farmerDTO.verificationDate
        )
    }
}

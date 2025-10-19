//
//  UserMapper.swift
//  coffee-ios
//
//  Created by Jeisson Chacon on 18/10/25.
//

import Foundation

// MARK: - UserMapper
class UserMapper {
    
    /// Maps User (Domain) to UserDTO (Data)
    func mapToDTO(_ user: User) -> UserDTO {
        return UserDTO(
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            idCard: user.idCard,
            email: user.email,
            phone: user.phone,
            state: user.state,
            city: user.city,
            zipCode: user.zipCode,
            address: user.address,
            bornDate: user.bornDate,
            type: mapUserTypeToDTO(user.type),
            registrationDate: user.registrationDate
        )
    }
    
    /// Maps UserDTO (Data) to User (Domain)
    func mapToDomain(_ userDTO: UserDTO) -> User {
        return User(
            id: userDTO.id,
            firstName: userDTO.firstName,
            lastName: userDTO.lastName,
            idCard: userDTO.idCard,
            email: userDTO.email,
            phone: userDTO.phone,
            state: userDTO.state,
            city: userDTO.city,
            zipCode: userDTO.zipCode,
            address: userDTO.address,
            bornDate: userDTO.bornDate,
            type: mapUserTypeToDomain(userDTO.type),
            registrationDate: userDTO.registrationDate
        )
    }
    
    // MARK: - Private Methods
    
    private func mapUserTypeToDTO(_ type: User.UserType) -> UserDTO.UserType {
        switch type {
        case .customer:
            return .customer
        case .coffeeFarmer:
            return .coffeeFarmer
        case .admin:
            return .admin
        }
    }
    
    private func mapUserTypeToDomain(_ type: UserDTO.UserType) -> User.UserType {
        switch type {
        case .customer:
            return .customer
        case .coffeeFarmer:
            return .coffeeFarmer
        case .admin:
            return .admin
        }
    }
}

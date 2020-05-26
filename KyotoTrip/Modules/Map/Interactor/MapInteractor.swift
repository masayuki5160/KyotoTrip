//
//  KyotoMapUseCase.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/10.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

protocol MapInteractorProtocol: AnyObject {
    func updateUserPosition(_ position: UserPosition) -> UserPosition
    func createMarkerEntity(category: MarkerCategory, coordinate: CLLocationCoordinate2D, attributes: [String: Any]) -> MarkerEntityProtocol
}

final class MapInteractor: MapInteractorProtocol {
    
    func updateUserPosition(_ position: UserPosition) -> UserPosition {
        let nextStatusRawValue = position.rawValue + 1
        let nextStatus = UserPosition(rawValue: nextStatusRawValue) ?? UserPosition.kyotoCity
        
        return nextStatus
    }
    
    func createMarkerEntity(category: MarkerCategory, coordinate:CLLocationCoordinate2D, attributes: [String: Any]) -> MarkerEntityProtocol {
        switch category {
        case .Busstop:
            return BusstopMarkerEntity(
                title: attributes[BusstopMarkerEntity.titleId] as! String,
                subtitle: "",
                coordinate: coordinate,
                type: .Busstop
            )
        case .CulturalProperty:
            return CulturalPropertyMarkerEntity(
                title: attributes[CulturalPropertyMarkerEntity.titleId] as! String,
                coordinate: coordinate,
                address: attributes[CulturalPropertyMarkerEntity.addressId] as! String,
                largeClassificationCode: attributes[CulturalPropertyMarkerEntity.largeClassificationCodeId] as! Int,
                smallClassificationCode: attributes[CulturalPropertyMarkerEntity.smallClassificationCodeId] as! Int,
                registerdDate: attributes[CulturalPropertyMarkerEntity.registerdDateId] as! Int
            )
        default:
            // TODO: Fix later
            return BusstopMarkerEntity(title: "", subtitle: "", coordinate: coordinate, type: .Busstop)
        }
    }
}

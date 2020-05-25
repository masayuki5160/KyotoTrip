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
    func createVisibleFeature(category: MarkerCategory, coordinate: CLLocationCoordinate2D, attributes: [String: Any]) -> VisibleFeatureProtocol
}

final class MapInteractor: MapInteractorProtocol {
    
    func updateUserPosition(_ position: UserPosition) -> UserPosition {
        let nextStatusRawValue = position.rawValue + 1
        let nextStatus = UserPosition(rawValue: nextStatusRawValue) ?? UserPosition.kyotoCity
        
        return nextStatus
    }
    
    func createVisibleFeature(category: MarkerCategory, coordinate:CLLocationCoordinate2D, attributes: [String: Any]) -> VisibleFeatureProtocol {
        switch category {
        case .Busstop:
            return BusstopFeatureEntity(
                title: attributes[BusstopFeatureEntity.titleId] as! String,
                subtitle: "",
                coordinate: coordinate,
                type: .Busstop
            )
        case .CulturalProperty:
            return CulturalPropertyFeatureEntity(
                title: attributes[CulturalPropertyFeatureEntity.titleId] as! String,
                coordinate: coordinate,
                address: attributes[CulturalPropertyFeatureEntity.addressId] as! String,
                largeClassificationCode: attributes[CulturalPropertyFeatureEntity.largeClassificationCodeId] as! Int,
                smallClassificationCode: attributes[CulturalPropertyFeatureEntity.smallClassificationCodeId] as! Int,
                registerdDate: attributes[CulturalPropertyFeatureEntity.registerdDateId] as! Int
            )
        default:
            // TODO: Fix later
            return BusstopFeatureEntity(title: "", subtitle: "", coordinate: coordinate, type: .Busstop)
        }
    }
}

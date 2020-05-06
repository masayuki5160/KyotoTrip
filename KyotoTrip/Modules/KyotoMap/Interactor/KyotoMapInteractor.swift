//
//  KyotoMapUseCase.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/10.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

protocol KyotoMapInteractorProtocol: AnyObject {
    func updateCulturalPropertylayer(_ layer: VisibleLayer) -> VisibleLayer
    func updateBusstopLayer(_ layer: VisibleLayer) -> VisibleLayer
    func updateUserPosition(_ position: UserPosition) -> UserPosition
    func createVisibleFeature(category: VisibleFeatureCategory, coordinate: CLLocationCoordinate2D, attributes: [String: Any]) -> VisibleFeatureProtocol
}

final class KyotoMapInteractor: KyotoMapInteractorProtocol {
    func updateCulturalPropertylayer(_ layer: VisibleLayer) -> VisibleLayer {
        let nextStatusRawValue = layer.culturalProperty.rawValue + 1
        let nextStatus = VisibleLayer.Status(rawValue: nextStatusRawValue) ?? VisibleLayer.Status.hidden
        let nextVisibleLayer = VisibleLayer(
            busstop: layer.busstop,
            culturalProperty: nextStatus,
            info: layer.info,
            rentalCycle: layer.rentalCycle,
            cycleParking: layer.cycleParking
        )

        return nextVisibleLayer
    }
    
    func updateBusstopLayer(_ layer: VisibleLayer) -> VisibleLayer {
        let nextStatusRawValue = layer.busstop.rawValue + 1
        let nextStatus = VisibleLayer.Status(rawValue: nextStatusRawValue) ?? VisibleLayer.Status.hidden
        let nextVisibleLayer = VisibleLayer(
            busstop: nextStatus,
            culturalProperty: layer.culturalProperty,
            info: layer.info,
            rentalCycle: layer.rentalCycle,
            cycleParking: layer.cycleParking
        )
        
        return nextVisibleLayer
    }
    
    func updateUserPosition(_ position: UserPosition) -> UserPosition {
        let nextStatusRawValue = position.rawValue + 1
        let nextStatus = UserPosition(rawValue: nextStatusRawValue) ?? UserPosition.kyotoCity
        
        return nextStatus
    }
    
    func createVisibleFeature(category: VisibleFeatureCategory, coordinate:CLLocationCoordinate2D, attributes: [String: Any]) -> VisibleFeatureProtocol {
        switch category {
        case .Busstop:
            return BusstopFeature(
                title: attributes[BusstopFeature.titleId] as! String,
                subtitle: "",
                coordinate: coordinate,
                type: .Busstop
            )
        case .CulturalProperty:
            return CulturalPropertyFeature(
                title: attributes[CulturalPropertyFeature.titleId] as! String,
                subtitle: "",
                coordinate: coordinate,
                type: .CulturalProperty
            )
        default:
            // TODO: Fix later
            return BusstopFeature(title: "", subtitle: "", coordinate: coordinate, type: .Busstop)
        }
    }
}

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
    func createBusstopDetailViewData(marker: BusstopMarkerEntity) -> BusstopDetailViewData
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
                coordinate: coordinate,
                routeNameString: attributes[BusstopMarkerEntity.busRouteId] as! String,
                organizationNameString: attributes[BusstopMarkerEntity.organizationId] as! String
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
            return BusstopMarkerEntity(title: "", coordinate: coordinate)
        }
    }
    
    func createBusstopDetailViewData(marker: BusstopMarkerEntity) -> BusstopDetailViewData {
        let viewData = BusstopDetailViewData(
            name: marker.title,
            routes: marker.routes,
            organizations: marker.organizations
        )
        
        return viewData
    }
}

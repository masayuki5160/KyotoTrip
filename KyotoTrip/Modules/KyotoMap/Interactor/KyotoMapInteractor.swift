//
//  KyotoMapUseCase.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/10.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import CoreLocation

protocol KyotoMapInteractorProtocol: AnyObject {
    func updateUserPosition(_ position: UserPosition) -> UserPosition
    func createVisibleFeature(category: VisibleFeatureCategory, coordinate: CLLocationCoordinate2D, attributes: [String: Any]) -> VisibleFeatureProtocol
    func fetchRestaurantData(complition: @escaping (Result<RestaurantSearchResultEntity, Error>) -> Void)
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayer) -> VisibleLayer
}

final class KyotoMapInteractor: KyotoMapInteractorProtocol {
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayer) -> VisibleLayer {
        var next = current
        return next.update(layer: target)
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
    
    func fetchRestaurantData(complition: @escaping (Result<RestaurantSearchResultEntity, Error>) -> Void) {
        let restaurantInfoGateway = RestaurantInfoGateway()
        restaurantInfoGateway.fetch { response in
            switch response {
            case .success(let data):
                complition(.success(data))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}

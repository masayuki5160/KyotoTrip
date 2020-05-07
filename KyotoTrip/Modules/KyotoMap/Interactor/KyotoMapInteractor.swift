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
    func createRestaurantVisibleFeature(source: RestaurantEntity) -> RestaurantFeatureEntity
    func fetchRestaurantData(complition: @escaping (Result<RestaurantSearchResultEntity, Error>) -> Void)
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayerEntity) -> VisibleLayerEntity
}

final class KyotoMapInteractor: KyotoMapInteractorProtocol {
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayerEntity) -> VisibleLayerEntity {
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
            return BusstopFeatureEntity(
                title: attributes[BusstopFeatureEntity.titleId] as! String,
                subtitle: "",
                coordinate: coordinate,
                type: .Busstop
            )
        case .CulturalProperty:
            return CulturalPropertyFeatureEntity(
                title: attributes[CulturalPropertyFeatureEntity.titleId] as! String,
                subtitle: "",
                coordinate: coordinate,
                type: .CulturalProperty
            )
        default:
            // TODO: Fix later
            return BusstopFeatureEntity(title: "", subtitle: "", coordinate: coordinate, type: .Busstop)
        }
    }
    
    func createRestaurantVisibleFeature(source: RestaurantEntity) -> RestaurantFeatureEntity {
        let latitude = atof(source.location.latitude)
        let longitude = atof(source.location.longitude)
        return RestaurantFeatureEntity(
            title: source.name.name,
            subtitle: source.categories.category,
            coordinate: CLLocationCoordinate2DMake(latitude, longitude),
            type: .Restaurant
        )
    }
    
    func fetchRestaurantData(complition: @escaping (Result<RestaurantSearchResultEntity, Error>) -> Void) {
        let restaurantInfoGateway = RestaurantInfoGateway()
        let requestParam = RestaurantInfoRequestParam()
        restaurantInfoGateway.fetch(param: requestParam) { response in
            switch response {
            case .success(let data):
                complition(.success(data))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}

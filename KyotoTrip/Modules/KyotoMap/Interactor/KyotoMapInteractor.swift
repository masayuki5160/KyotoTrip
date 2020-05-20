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
    func fetchRestaurants(location: CLLocationCoordinate2D, complition: @escaping (Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void)
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayerEntity) -> VisibleLayerEntity
}

final class KyotoMapInteractor: KyotoMapInteractorProtocol {
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
    
    func createRestaurantVisibleFeature(source: RestaurantEntity) -> RestaurantFeatureEntity {
        let latitude = atof(source.location.latitudeWgs84)
        let longitude = atof(source.location.longitudeWgs84)
        return RestaurantFeatureEntity(
            title: source.name.name,
            subtitle: source.categories.category,
            coordinate: CLLocationCoordinate2DMake(latitude, longitude),
            type: .Restaurant,
            detail: source
        )
    }
    
    func fetchRestaurants(location: CLLocationCoordinate2D, complition: @escaping (Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void) {
        let gateway = RestaurantsSearchGateway()
        let requestParam = createRestaurantsRequestParam(location: location)

        gateway.fetch(param: requestParam) { response in
            switch response {
            case .success(let restaurants):
                complition(.success(restaurants))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayerEntity) -> VisibleLayerEntity {
        return current.update(layer: target)
    }
}

private extension KyotoMapInteractor {
    private func createRestaurantsRequestParam(location: CLLocationCoordinate2D) -> RestaurantsRequestParamEntity {
        let requestParamGateway = RestaurantsRequestParamGateway()
        var param = requestParamGateway.fetch()
        param.latitude = String(location.latitude)
        param.longitude = String(location.longitude)

        return param
    }
}

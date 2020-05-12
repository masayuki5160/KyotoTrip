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
    func fetchRestaurantData(location: CLLocationCoordinate2D, complition: @escaping (Result<RestaurantSearchResultEntity, Error>) -> Void)
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayerEntity) -> VisibleLayerEntity
}

final class KyotoMapInteractor: KyotoMapInteractorProtocol {
    func nextVisibleLayer(target: VisibleFeatureCategory, current: VisibleLayerEntity) -> VisibleLayerEntity {
        return current.update(layer: target)
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
        let latitude = atof(source.location.latitude)
        let longitude = atof(source.location.longitude)
        return RestaurantFeatureEntity(
            title: source.name.name,
            subtitle: source.categories.category,
            coordinate: CLLocationCoordinate2DMake(latitude, longitude),
            type: .Restaurant,
            detail: source
        )
    }
    
    func fetchRestaurantData(location: CLLocationCoordinate2D, complition: @escaping (Result<RestaurantSearchResultEntity, Error>) -> Void) {
        let restaurantInfoGateway = RestaurantInfoGateway()
        let requestParam = createRestaurantInfoRequestParam(location: location)
        restaurantInfoGateway.fetch(param: requestParam) { response in
            switch response {
            case .success(let data):
                complition(.success(data))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    private func createRestaurantInfoRequestParam(location: CLLocationCoordinate2D) -> RestaurantInfoRequestParamEntity {
        var param = RestaurantInfoRequestParamEntity().load()
        param.latitude = String(location.latitude)
        param.longitude = String(location.longitude)

        return param
    }
}

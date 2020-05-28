//
//  CategoryInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import CoreLocation

protocol CategoryInteractorProtocol {
    func nextVisibleLayer(target: MarkerCategory, current: MarkerCategoryEntity) -> MarkerCategoryEntity
    func fetchRestaurants(location: CLLocationCoordinate2D, complition: @escaping (Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void)
    func createRestaurantVisibleFeature(source: RestaurantEntity) -> RestaurantMarkerEntity
}

class CategoryInteractor: CategoryInteractorProtocol {
    
    struct Dependency {
        let searchGateway: RestaurantsSearchGatewayProtocol
        let requestParamGateway: RestaurantsRequestParamGatewayProtocol
    }
    
    private var dependency: Dependency!
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func nextVisibleLayer(target: MarkerCategory, current: MarkerCategoryEntity) -> MarkerCategoryEntity {
        return current.update(category: target)
    }
    
    func fetchRestaurants(location: CLLocationCoordinate2D, complition: @escaping (Result<RestaurantsSearchResultEntity, RestaurantsSearchResponseError>) -> Void) {
        createRestaurantsRequestParam(location: location) { [weak self] requestParam in
            self?.dependency.searchGateway.fetch(param: requestParam) { response in
                switch response {
                case .success(let restaurants):
                    complition(.success(restaurants))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
        }
    }
    
    func createRestaurantVisibleFeature(source: RestaurantEntity) -> RestaurantMarkerEntity {
        let latitude = atof(source.location.latitudeWgs84)
        let longitude = atof(source.location.longitudeWgs84)
        return RestaurantMarkerEntity(
            title: source.name.name,
            subtitle: source.categories.category,
            coordinate: CLLocationCoordinate2DMake(latitude, longitude),
            type: .Restaurant,
            detail: source
        )
    }
    
    private func createRestaurantsRequestParam(location: CLLocationCoordinate2D, compliton: (RestaurantsRequestParamEntity) -> Void) {
        dependency.requestParamGateway.fetch { response in
            var settings:RestaurantsRequestParamEntity

            switch response {
            case .failure(_):
                settings = RestaurantsRequestParamEntity()
            case .success(let savedSettings):
                settings = savedSettings
                settings.latitude = String(location.latitude)
                settings.longitude = String(location.longitude)
            }
            
            compliton(settings)
        }
    }
}

//
//  KyotoMapUseCase.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/10.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxSwift
import RxCocoa
import CoreLocation

protocol MapInteractorProtocol: AnyObject {
    /// Output from Presenter
    var visibleMarkerCategoryDriver: Driver<MarkerCategoryEntity> { get }
    var restaurantMarkersDriver: Driver<[RestaurantMarkerEntity]> { get }
    var visibleMarkers: Driver<[MarkerEntityProtocol]> { get }
    
    var selectedCategoryViewCellSignal: Signal<MarkerEntityProtocol> { get }
    func fetchRestaurants(location: CLLocationCoordinate2D, complition: @escaping (Result<[RestaurantMarkerEntity], RestaurantsSearchResponseError>) -> Void)
    
    var markerCategory: MarkerCategoryEntity { get }
    var mapViewCenterCoordinate: CLLocationCoordinate2D { get }

    /// Input to Presenter
    func updateVisibleLayer(entity: MarkerCategoryEntity)
    func updateRestaurantMarkers(entity: [RestaurantMarkerEntity])
    func updateMarkersFromStyleLayers(entity: [MarkerEntityProtocol])
    func didSelectCategoryViewCell(entity: MarkerEntityProtocol)
    func updateMapViewViewpoint(centerCoordinate: CLLocationCoordinate2D)
}

class MapInteractor: MapInteractorProtocol {
    
    struct Dependency {
        let searchGateway: RestaurantsSearchGatewayProtocol
        let requestParamGateway: RestaurantsRequestParamGatewayProtocol
    }

    var mapViewCenterCoordinate: CLLocationCoordinate2D
        = CLLocationCoordinate2D(latitude: MapView.kyotoStationLat, longitude: MapView.kyotoStationLong)

    var visibleMarkerCategoryDriver: Driver<MarkerCategoryEntity> {
        return markerCategoryRelay.asDriver()
    }
    var restaurantMarkersDriver: Driver<[RestaurantMarkerEntity]> {
        return restaurantMarkersRelay.asDriver()
    }
    var visibleMarkers: Driver<[MarkerEntityProtocol]> {
        let driver = Driver.combineLatest(
            restaurantMarkersDriver,
            markersFromStyleLayersRelay.asDriver()
        ){ $0 + $1 }
        return driver
    }
    
    var selectedCategoryViewCellSignal: Signal<MarkerEntityProtocol> {
        return selectedCategoryViewCellRelay.asSignal()
    }
    
    // TODO: あとで修正
    var markerCategory: MarkerCategoryEntity {
        return markerCategoryRelay.value
    }
    
    private var dependency: Dependency!
    private let markerCategoryRelay = BehaviorRelay<MarkerCategoryEntity>(value: MarkerCategoryEntity())
    private let restaurantMarkersRelay = BehaviorRelay<[RestaurantMarkerEntity]>(value: [])
    private let markersFromStyleLayersRelay = BehaviorRelay<[MarkerEntityProtocol]>(value: [])
    private let selectedCategoryViewCellRelay = PublishRelay<MarkerEntityProtocol>()

    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func fetchRestaurants(location: CLLocationCoordinate2D, complition: @escaping (Result<[RestaurantMarkerEntity], RestaurantsSearchResponseError>) -> Void) {
        createRestaurantsRequestParam(location: location) { [weak self] requestParam in
            self?.dependency.searchGateway.fetch(param: requestParam) { response in
                guard let self = self else { return }

                switch response {
                case .success(let restaurants):
                    var markers: [RestaurantMarkerEntity] = []
                    for restaurant in restaurants.rest {
                        let marker = self.createRestaurantMarker(source: restaurant)
                        markers.append(marker)
                    }
                    
                    complition(.success(markers))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
        }
    }
    
    func updateMapViewViewpoint(centerCoordinate: CLLocationCoordinate2D) {
        self.mapViewCenterCoordinate = centerCoordinate
    }
    
    func updateVisibleLayer(entity: MarkerCategoryEntity) {
        markerCategoryRelay.accept(entity)
    }
    
    func updateRestaurantMarkers(entity: [RestaurantMarkerEntity]) {
        restaurantMarkersRelay.accept(entity)
    }
    
    func updateMarkersFromStyleLayers(entity: [MarkerEntityProtocol]) {
        markersFromStyleLayersRelay.accept(entity)
    }
    
    func didSelectCategoryViewCell(entity: MarkerEntityProtocol) {
        selectedCategoryViewCellRelay.accept(entity)
    }
}

private extension MapInteractor {
    private func createRestaurantMarker(source: RestaurantEntity) -> RestaurantMarkerEntity {
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
                // Set default settings
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

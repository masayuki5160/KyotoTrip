//
//  MapInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/10.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxSwift
import RxCocoa
import CoreLocation

protocol MapInteractorProtocol: AnyObject {
    /// Output from Interactor for Presenter
    var restaurantMarkersDriver: Driver<[RestaurantMarkerEntity]> { get }
    var visibleMarkers: Driver<[MarkerEntityProtocol]> { get }
    var culturalPropertyStatusDriver: Driver<CategoryButtonStatus> { get }
    var restaurantStatusDriver: Driver<CategoryButtonStatus> { get }
    var busstopStatusDriver: Driver<CategoryButtonStatus> { get }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> { get }
    
    /// Input to Interactor
    func updateMarkersFromStyleLayers(entity: [MarkerEntityProtocol])
    func didSelectCategoryViewCell(viewData: MarkerViewDataProtocol)
    func updateMapViewViewpoint(centerCoordinate: CLLocationCoordinate2D)
    func didSelectBusstopButton(nextStatus: CategoryButtonStatus)
    func didSelectCulturalPropertyButton(nextStatus: CategoryButtonStatus)
    func didSelectRestaurantButton(nextStatus: CategoryButtonStatus)
}

class MapInteractor: MapInteractorProtocol {
    
    struct Dependency {
        let searchGateway: RestaurantsSearchGatewayProtocol
        let requestParamGateway: RestaurantsRequestParamGatewayProtocol
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
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> {
        return selectedCategoryViewCellRelay.asSignal()
    }
    var culturalPropertyStatusDriver: Driver<CategoryButtonStatus> {
        return culturalPropertyStatusRelay.asDriver()
    }
    var restaurantStatusDriver: Driver<CategoryButtonStatus> {
        return restaurantStatusRelay.asDriver()
    }
    var busstopStatusDriver: Driver<CategoryButtonStatus> {
        return busstopStatusRelay.asDriver()
    }
    /// Relay vars using Rx
    private let restaurantMarkersRelay = BehaviorRelay<[RestaurantMarkerEntity]>(value: [])
    private let markersFromStyleLayersRelay = BehaviorRelay<[MarkerEntityProtocol]>(value: [])
    private let selectedCategoryViewCellRelay = PublishRelay<MarkerViewDataProtocol>()
    private let culturalPropertyStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)
    private let restaurantStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)
    private let busstopStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)

    private var dependency: Dependency!
    private var mapViewCenterCoordinate: CLLocationCoordinate2D
        = CLLocationCoordinate2D(latitude: MapView.kyotoStationLat, longitude: MapView.kyotoStationLong)
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func updateMapViewViewpoint(centerCoordinate: CLLocationCoordinate2D) {
        mapViewCenterCoordinate = centerCoordinate
    }
    
    func updateMarkersFromStyleLayers(entity: [MarkerEntityProtocol]) {
        markersFromStyleLayersRelay.accept(entity)
    }
    
    func didSelectCategoryViewCell(viewData: MarkerViewDataProtocol) {
        selectedCategoryViewCellRelay.accept(viewData)
    }
    
    func didSelectBusstopButton(nextStatus: CategoryButtonStatus) {
        busstopStatusRelay.accept(nextStatus)
    }
    
    func didSelectCulturalPropertyButton(nextStatus: CategoryButtonStatus) {
        culturalPropertyStatusRelay.accept(nextStatus)
    }
    
    func didSelectRestaurantButton(nextStatus: CategoryButtonStatus) {
        restaurantStatusRelay.accept(nextStatus)
        
        switch nextStatus {
        case .hidden:
            restaurantMarkersRelay.accept([])
        case .visible:
            fetchRestaurants { [weak self] response in
                guard let self = self else { return }
                
                var markers: [RestaurantMarkerEntity] = []
                switch response {
                case .success(let restaurantMarkers):
                    markers = restaurantMarkers
                default:
                    // TODO: エラー状態をpresenterに渡せるようにしたい
                    break
                }
                
                self.restaurantMarkersRelay.accept(markers)
            }
        }
    }
}

private extension MapInteractor {
    private func fetchRestaurants(complition: @escaping (Result<[RestaurantMarkerEntity], RestaurantsSearchResponseError>) -> Void) {
        createRestaurantsRequestParam(location: mapViewCenterCoordinate) { [weak self] requestParam in
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
}

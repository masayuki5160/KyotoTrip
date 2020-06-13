//
//  MapInteractorStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
@testable import KyotoTrip
import RxSwift
import RxCocoa
import CoreLocation

class MapInteractorStub: MapInteractorProtocol {
    var restaurantMarkersDriver: Driver<[RestaurantMarkerEntity]> {
        return restaurantMarkersRelay.asDriver()
    }
    var visibleMarkers: Driver<[MarkerEntityProtocol]> {
        return markersRelay.asDriver()
    }
    var culturalPropertyStatusDriver: Driver<CategoryButtonStatus> {
        return culturalPropertyStatusRelay.asDriver()
    }
    var busstopStatusDriver: Driver<CategoryButtonStatus> {
        return busstopStatusRelay.asDriver()
    }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> {
        return selectedCategoryViewCellRelay.asSignal()
    }
    
    struct Dependency {
        let searchGateway: RestaurantsSearchGatewayProtocol
        let requestParamGateway: RestaurantsRequestParamGatewayProtocol
    }
    
    private let dependency: Dependency
    private var restaurantMarkersRelay = BehaviorRelay<[RestaurantMarkerEntity]>(value: [])
    private var markersRelay = BehaviorRelay<[MarkerEntityProtocol]>(value: [])
    private var selectedCategoryViewCellRelay = PublishRelay<MarkerViewDataProtocol>()
    private var culturalPropertyStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)
    private var busstopStatusRelay = BehaviorRelay<CategoryButtonStatus>(value: .hidden)
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func updateMarkersFromStyleLayers(entity: [MarkerEntityProtocol]) {
        markersRelay.accept(entity)
    }
    
    func didSelectCategoryViewCell(viewData: MarkerViewDataProtocol) {
        selectedCategoryViewCellRelay.accept(viewData)
    }
    
    func updateMapViewViewpoint(centerCoordinate: CLLocationCoordinate2D) {
    }
    
    func didSelectBusstopButton(nextStatus: CategoryButtonStatus) {
        busstopStatusRelay.accept(nextStatus)
    }
    
    func didSelectCulturalPropertyButton(nextStatus: CategoryButtonStatus) {
        culturalPropertyStatusRelay.accept(nextStatus)
    }
    
    func didSelectRestaurantButton(nextStatus: CategoryButtonStatus) {
        switch nextStatus {
        case .visible:
            restaurantMarkersRelay.accept([
                RestaurantMarkerEntity(),
                RestaurantMarkerEntity()
            ])
        case .hidden:
            restaurantMarkersRelay.accept([])
        }
    }
}

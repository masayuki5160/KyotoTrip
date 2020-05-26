//
//  CommonMapPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxSwift
import RxCocoa
import CoreLocation
import Mapbox

protocol CommonMapPresenterProtocol {
    /// Visible layer status entity
    var markerCategoryRelay: BehaviorRelay<MarkerCategoryEntity> { get }
    /// Restaurants data from GNavi API
    var restaurantMarkersRelay: BehaviorRelay<[RestaurantMarkerEntity]> { get }
    /// Selected cell at category view
    var selectedCategoryViewCellRelay: BehaviorRelay<MarkerEntityProtocol> { get }
    /// Datas from mapview through Mapbox server
    var visibleFeatureEntity: BehaviorRelay<[MarkerEntityProtocol]> { get }
    
    func centerCoordinate(complition: (CLLocationCoordinate2D) -> (Void))
    func inject(mapView: MGLMapView)
}

class CommonMapPresenter: CommonMapPresenterProtocol {
    
    static let shared = CommonMapPresenter()
    
    let markerCategoryRelay = BehaviorRelay<MarkerCategoryEntity>(value: MarkerCategoryEntity())
    let restaurantMarkersRelay = BehaviorRelay<[RestaurantMarkerEntity]>(value: [])
    let selectedCategoryViewCellRelay = BehaviorRelay<MarkerEntityProtocol>(value: BusstopMarkerEntity())
    let visibleFeatureEntity = BehaviorRelay<[MarkerEntityProtocol]>(value: [])
    
    private var mapView: MGLMapView? = nil
    
    init() {}
    
    func centerCoordinate(complition: (CLLocationCoordinate2D) -> (Void)) {
        if let mapView = mapView {
            complition(mapView.centerCoordinate)
        }
    }
    
    func inject(mapView: MGLMapView) {
        self.mapView = mapView
    }
}

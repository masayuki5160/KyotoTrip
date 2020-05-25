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
    var visibleLayerEntity: BehaviorRelay<VisibleLayerEntity> { get }
    /// Restaurants data from GNavi API
    var visibleFeatureRestaurantEntity: BehaviorRelay<[VisibleFeatureProtocol]> { get }
    /// Selected cell at category view
    var selectedCategoryViewCellRelay: BehaviorRelay<VisibleFeatureProtocol> { get }
    /// Datas from mapview through Mapbox server
    var visibleFeatureEntity: BehaviorRelay<[VisibleFeatureProtocol]> { get }
    
    func centerCoordinate(complition: (CLLocationCoordinate2D) -> (Void))
    func inject(mapView: MGLMapView)
}

class CommonMapPresenter: CommonMapPresenterProtocol {
    
    static let shared = CommonMapPresenter()
    
    let visibleLayerEntity = BehaviorRelay<VisibleLayerEntity>(value: VisibleLayerEntity())
    let visibleFeatureRestaurantEntity = BehaviorRelay<[VisibleFeatureProtocol]>(value: [])
    let selectedCategoryViewCellRelay = BehaviorRelay<VisibleFeatureProtocol>(value: BusstopFeatureEntity())
    let visibleFeatureEntity = BehaviorRelay<[VisibleFeatureProtocol]>(value: [])
    
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

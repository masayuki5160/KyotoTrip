//
//  MapPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/21.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreLocation
import Mapbox.MGLFeature

struct MapViewInput {
    let compassButtonTapEvent: Signal<Void>
}

protocol MapPresenterProtocol: AnyObject {
    // MARK: - Properties

    static var layerIdentifiers: Set<String> { get }

    // MARK: - Input to Presenter from MapView
    
    func bindMapView(input: MapViewInput)
    func updateVisibleMGLFeatures(mglFeatures: [MGLFeature])
    func updateViewpoint(centerCoordinate: CLLocationCoordinate2D)

    // MARK: - Output from Presenter for MapView

    var userPositionButtonStatusDriver: Driver<UserPosition> { get }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> { get }
    var categoryButtonsStatusDriver: Driver<CategoryButtonsStatusViewData> { get }
    var restaurantMarkersDriver: Driver<(CategoryButtonStatus, [CustomMGLPointAnnotation])> { get }
    
    // MARK: - Others
    
    func convertMGLFeatureToMarkerViewData(source: MGLFeature) -> MarkerViewDataProtocol
    func sorteMGLFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature]
    func tapOnCallout(viewData: MarkerViewDataProtocol)
}

class MapPresenter: MapPresenterProtocol {
    
    // MARK: - Properties
    struct Dependency {
        let interactor: MapInteractorProtocol
        let router: MapRouterProtocol
    }

    static var layerIdentifiers: Set<String> = [
        BusstopMarkerEntity.layerId,
        CulturalPropertyMarkerEntity.layerId
    ]
    
    var userPositionButtonStatusDriver: Driver<UserPosition> {
        return userPositionButtonStatus.asDriver()
    }
    var selectedCategoryViewCellSignal: Signal<MarkerViewDataProtocol> {
        return dependency.interactor.selectedCategoryViewCellSignal
    }
    var categoryButtonsStatusDriver: Driver<CategoryButtonsStatusViewData>
    var restaurantMarkersDriver: Driver<(CategoryButtonStatus, [CustomMGLPointAnnotation])>
    
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let userPositionButtonStatus = BehaviorRelay<UserPosition>(value: .kyotoCity)
    
    // MARK: - Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        categoryButtonsStatusDriver = Driver.combineLatest(
            dependency.interactor.busstopStatusDriver,
            dependency.interactor.culturalPropertyStatusDriver,
            dependency.interactor.restaurantStatusDriver
        ).map({ (busstop, culturalProperty, restaurant) -> CategoryButtonsStatusViewData in
            var buttonsStatus = CategoryButtonsStatusViewData()
            buttonsStatus.busstop = busstop
            buttonsStatus.culturalProperty = culturalProperty
            buttonsStatus.restaurant = restaurant

            return buttonsStatus
        })
        
        restaurantMarkersDriver = Driver.combineLatest(
            dependency.interactor.restaurantStatusDriver,
            dependency.interactor.restaurantMarkersDriver
        ).map({ (status, markers) -> (CategoryButtonStatus, [CustomMGLPointAnnotation]) in
            let annotations = markers.map { marker -> CustomMGLPointAnnotation in
                let viewData = RestaurantMarkerViewData(entity: marker)
                return CustomMGLPointAnnotation(viewData: viewData)
            }
            return (status, annotations)
        })
    }
    
    func bindMapView(input: MapViewInput) {
        input.compassButtonTapEvent.emit(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextPosition = self.userPositionButtonStatus.value.next()
            self.userPositionButtonStatus.accept(nextPosition)
        }).disposed(by: disposeBag)
    }
    
    func updateVisibleMGLFeatures(mglFeatures: [MGLFeature]) {
        let markers = mglFeatures.map { feature -> MarkerEntityProtocol in
            convertMGLFeatureToMarkerEntity(source: feature)
        }
        
        dependency.interactor.updateMarkersFromStyleLayers(entity: markers)
    }
    
    func sorteMGLFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature] {
        return features.sorted(by: {
            let distanceFromLocationA =
                CLLocation(latitude: $0.coordinate.latitude,longitude: $0.coordinate.longitude)
                    .distance(from: center)
            let distanceFromLocationB =
                CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude)
                    .distance(from: center)
            
            return distanceFromLocationA < distanceFromLocationB
        })
    }
    
    func tapOnCallout(viewData: MarkerViewDataProtocol) {
        dependency.router.transitionToDetailViewController(inject: viewData)
    }
    
    func updateViewpoint(centerCoordinate: CLLocationCoordinate2D) {
        dependency.interactor.updateMapViewViewpoint(centerCoordinate: centerCoordinate)
    }
    
    func convertMGLFeatureToMarkerViewData(source: MGLFeature) -> MarkerViewDataProtocol {
        let markerEntity = convertMGLFeatureToMarkerEntity(source: source)
        switch markerEntity.type {
        case .Busstop:
            return BusstopMarkerViewData(entity: markerEntity as! BusstopMarkerEntity)
        case .CulturalProperty:
            return CulturalPropertyMarkerViewData(entity: markerEntity as! CulturalPropertyMarkerEntity)
        case .Restaurant:
            return RestaurantMarkerViewData(entity: markerEntity as! RestaurantMarkerEntity)
        default:
            return BusstopMarkerViewData(entity: markerEntity as! BusstopMarkerEntity)
        }
    }
}

private extension MapPresenter {
    
    // MARK: - Create entity/viewdata private methods
    
    private func convertMGLFeatureToMarkerEntity(source: MGLFeature) -> MarkerEntityProtocol {
        let category: MarkerCategory
        if (source.attribute(forKey: BusstopMarkerEntity.titleId) != nil) {
            category = .Busstop
        } else if ((source.attribute(forKey: CulturalPropertyMarkerEntity.titleId)) != nil) {
            category = .CulturalProperty
        } else {
            // Fix me later
            category = .Busstop
        }
        
        switch category {
        case .Busstop:
            return BusstopMarkerEntity(
                title: source.attributes[BusstopMarkerEntity.titleId] as! String,
                coordinate: source.coordinate,
                routeNameString: source.attributes[BusstopMarkerEntity.busRouteId] as! String,
                organizationNameString: source.attributes[BusstopMarkerEntity.organizationId] as! String
            )
        case .CulturalProperty:
            return CulturalPropertyMarkerEntity(
                title: source.attributes[CulturalPropertyMarkerEntity.titleId] as! String,
                coordinate: source.coordinate,
                address: source.attributes[CulturalPropertyMarkerEntity.addressId] as! String,
                largeClassificationCode: source.attributes[CulturalPropertyMarkerEntity.largeClassificationCodeId] as! Int,
                smallClassificationCode: source.attributes[CulturalPropertyMarkerEntity.smallClassificationCodeId] as! Int,
                registerdDate: source.attributes[CulturalPropertyMarkerEntity.registerdDateId] as! Int
            )
        default:
            // TODO: Fix later
            return BusstopMarkerEntity(title: "", coordinate: source.coordinate)
        }
    }
}

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
    let compassButtonTapEvent: Driver<Void>
}

protocol MapPresenterProtocol: AnyObject {
    // MARK: - Properties

    static var layerIdentifiers: Set<String> { get }

    // MARK: - Input to Presenter
    
    func bindMapView(input: MapViewInput)
    func updateVisibleMGLFeatures(mglFeatures: [MGLFeature])
    func updateViewpoint(centerCoordinate: CLLocationCoordinate2D)

    // MARK: - Output from Presenter

    var userPositionButtonStatusDriver: Driver<UserPosition> { get }
    var selectedCategoryViewCellDriver: Driver<MarkerEntityProtocol> { get }
    var markersDriver: Driver<(MarkerCategoryEntity, [CustomMGLPointAnnotation])> { get }
    
    // MARK: - Others
    
    func convertMGLFeatureToMarkerEntity(source: MGLFeature) -> MarkerEntityProtocol
    func sorteMGLFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature]
    func tapOnCallout(marker: MarkerEntityProtocol, category: MarkerCategory)
}

class MapPresenter: MapPresenterProtocol {
    
    // MARK: - Properties
    struct Dependency {
        let interactor: MapInteractorProtocol
        let sharedPresenter: SharedMapPresenterProtocol
        let router: MapRouterProtocol
    }

    static var layerIdentifiers: Set<String> = [
        BusstopMarkerEntity.layerId,
        CulturalPropertyMarkerEntity.layerId
    ]
    
    var userPositionButtonStatusDriver: Driver<UserPosition> {
        return userPositionButtonStatus.asDriver()
    }
    var selectedCategoryViewCellDriver: Driver<MarkerEntityProtocol> {
        return dependency.sharedPresenter.selectedCategoryViewCellRelay.asDriver()
    }
    var markersDriver: Driver<(MarkerCategoryEntity, [CustomMGLPointAnnotation])>
    
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let userPositionButtonStatus = BehaviorRelay<UserPosition>(value: .kyotoCity)
    
    // MARK: - Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        markersDriver = Driver.combineLatest(
            dependency.sharedPresenter.markerCategoryRelay.asDriver(),
            dependency.sharedPresenter.restaurantMarkersRelay.asDriver()
        ){($0, $1)}
            .map({ (markerCategory, restaurantMarkers) -> (MarkerCategoryEntity, [CustomMGLPointAnnotation]) in
                let annotations = restaurantMarkers.map { marker -> CustomMGLPointAnnotation in
                    CustomMGLPointAnnotation(entity: marker)
                }
                return (markerCategory, annotations)
            })
    }
    
    func bindMapView(input: MapViewInput) {
        input.compassButtonTapEvent.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextPosition = self.updateUserPosition(self.userPositionButtonStatus.value)
            self.userPositionButtonStatus.accept(nextPosition)
        }).disposed(by: disposeBag)
    }
    
    func updateVisibleMGLFeatures(mglFeatures: [MGLFeature]) {
        let markers = mglFeatures.map { feature -> MarkerEntityProtocol in
            convertMGLFeatureToMarkerEntity(source: feature)
        }
        
        dependency.sharedPresenter.markersFromStyleLayersRelay.accept(markers)
    }
    
    func convertMGLFeatureToMarkerEntity(source: MGLFeature) -> MarkerEntityProtocol {
        let category = dependency.sharedPresenter.markerCategoryRelay.value.visibleCategory()        
        return createMarkerEntity(
            category: category,
            coordinate: source.coordinate,
            attributes: source.attributes
        )
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
    
    func tapOnCallout(marker: MarkerEntityProtocol, category: MarkerCategory) {
        switch category {
        case .Busstop:
            let busstopMarker = marker as! BusstopMarkerEntity
            let busstopDetailViewData = createBusstopDetailViewData(marker: busstopMarker)
            
            dependency.router
                .transitionToBusstopDetailViewController(inject: busstopDetailViewData)
        case .CulturalProperty:
            let culturalPropertyMarker = marker as! CulturalPropertyMarkerEntity
            let culturalPropertyDetailViewData = createCulturalPropertyDetailViewData(marker: culturalPropertyMarker)
            
            dependency.router
                .transitionToCulturalPropertyDetailViewController(inject: culturalPropertyDetailViewData)
        case .Restaurant:
            let restaurantMarker = marker as! RestaurantMarkerEntity
            let restaurantDetailViewData = createRestaurantDetailViewData(marker: restaurantMarker)
            dependency.router
                .transitionToRestaurantDetailViewController(inject: restaurantDetailViewData)
        default:
            break
        }
    }
    
    func updateViewpoint(centerCoordinate: CLLocationCoordinate2D) {
        dependency.sharedPresenter.updateMapViewViewpoint(centerCoordinate: centerCoordinate)
    }
}

private extension MapPresenter {
    
    // MARK: - Create entity/viewdata private methods
    
    private func createBusstopDetailViewData(marker: BusstopMarkerEntity) -> BusstopDetailViewData {
        let viewData = BusstopDetailViewData(
            name: marker.title,
            routes: marker.routes,
            organizations: marker.organizations
        )
        
        return viewData
    }
    
    private func createCulturalPropertyDetailViewData(marker: CulturalPropertyMarkerEntity) -> CulturalPropertyDetailViewData {
        let viewData = CulturalPropertyDetailViewData(
            name: marker.title,
            address: marker.address,
            largeClassification: marker.largeClassification,
            smallClassification: marker.smallClassification,
            registerdDate: marker.registerDateString
        )
        
        return viewData
    }
    
    private func createRestaurantDetailViewData(marker: RestaurantMarkerEntity) -> RestaurantDetailViewData {
        if let detail = marker.detail {
            return RestaurantDetailViewData(
                name: detail.name.name,
                nameKana: detail.name.nameKana,
                address: detail.contacts.address,
                access: detail.access,
                tel: detail.contacts.tel,
                businessHour: detail.businessHour,
                holiday: detail.holiday,
                salesPoint: detail.salesPoints.prLong,
                url: detail.url,
                imageUrl: detail.imageUrl.thumbnail
            )
        } else {
            return RestaurantDetailViewData()
        }
    }
    
    private func createMarkerEntity(category: MarkerCategory, coordinate:CLLocationCoordinate2D, attributes: [String: Any]) -> MarkerEntityProtocol {
        switch category {
        case .Busstop:
            return BusstopMarkerEntity(
                title: attributes[BusstopMarkerEntity.titleId] as! String,
                coordinate: coordinate,
                routeNameString: attributes[BusstopMarkerEntity.busRouteId] as! String,
                organizationNameString: attributes[BusstopMarkerEntity.organizationId] as! String
            )
        case .CulturalProperty:
            return CulturalPropertyMarkerEntity(
                title: attributes[CulturalPropertyMarkerEntity.titleId] as! String,
                coordinate: coordinate,
                address: attributes[CulturalPropertyMarkerEntity.addressId] as! String,
                largeClassificationCode: attributes[CulturalPropertyMarkerEntity.largeClassificationCodeId] as! Int,
                smallClassificationCode: attributes[CulturalPropertyMarkerEntity.smallClassificationCodeId] as! Int,
                registerdDate: attributes[CulturalPropertyMarkerEntity.registerdDateId] as! Int
            )
        default:
            // TODO: Fix later
            return BusstopMarkerEntity(title: "", coordinate: coordinate)
        }
    }
    
    // MARK: - Other private methods
    
    private func updateUserPosition(_ position: UserPosition) -> UserPosition {
        let nextStatusRawValue = position.rawValue + 1
        let nextStatus = UserPosition(rawValue: nextStatusRawValue) ?? UserPosition.kyotoCity
        
        return nextStatus
    }
}

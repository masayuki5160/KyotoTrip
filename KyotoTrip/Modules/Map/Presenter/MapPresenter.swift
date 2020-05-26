//
//  MapViewModel.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/21.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxSwift
import RxCocoa
import Mapbox

struct MapViewInput {
    let compassButton: Driver<Void>
    let features: Driver<[MGLFeature]>
    let mapView: MGLMapView
}

protocol MapPresenterProtocol: AnyObject {
    // MARK: - Properties

    static var layerIdentifiers: Set<String> { get }

    // MARK: - Input to Presenter
    
    func bindMapView(input: MapViewInput)

    // MARK: - Output from Presenter

    var userPositionButtonStatusDriver: Driver<UserPosition> { get }
    var selectedCategoryViewCellDriver: Driver<MarkerEntityProtocol> { get }
    var markersDriver: Driver<(MarkerCategoryEntity, [MGLPointAnnotation])> { get }
    
    // MARK: - Others
    
    func convertMGLFeatureToMarkerEntity(source: MGLFeature) -> MarkerEntityProtocol
    func sorteFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature]
}

class MapPresenter: MapPresenterProtocol {
    
    // MARK: - Properties
    struct Dependency {
        let interactor: MapInteractorProtocol
        let commonPresenter: CommonMapPresenterProtocol
        let router: MapViewRouterProtocol
    }

    static var layerIdentifiers: Set<String> = [
        BusstopMarkerEntity.layerId,
        CulturalPropertyMarkerEntity.layerId
    ]
    
    var userPositionButtonStatusDriver: Driver<UserPosition> {
        return userPositionButtonStatus.asDriver()
    }
    var selectedCategoryViewCellDriver: Driver<MarkerEntityProtocol> {
        return dependency.commonPresenter.selectedCategoryViewCellRelay.asDriver()
    }
    var markersDriver: Driver<(MarkerCategoryEntity, [MGLPointAnnotation])>
    
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let userPositionButtonStatus = BehaviorRelay<UserPosition>(value: .kyotoCity)
    
    // MARK: - Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        markersDriver = Driver.combineLatest(
            dependency.commonPresenter.visibleLayerEntity.asDriver(),
            dependency.commonPresenter.visibleFeatureRestaurantEntity.asDriver()
        ){($0, $1)}
            .map({ (visibleLayer, features) -> (MarkerCategoryEntity, [MGLPointAnnotation]) in
                var annotations: [RestaurantPointAnnotation] = []
                for feature in features {
                    let annotation = RestaurantPointAnnotation(entity: feature as! RestaurantMarkerEntity)
                    annotations.append(annotation)
                }
                return (visibleLayer, annotations)
            })
    }
    
    func bindMapView(input: MapViewInput) {

        /// Subscribe from MapView
        
        input.compassButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextPosition = self.dependency.interactor.updateUserPosition(self.userPositionButtonStatus.value)
            self.userPositionButtonStatus.accept(nextPosition)
        }).disposed(by: disposeBag)
        
        input.features.map({ [weak self] (features) -> [MarkerEntityProtocol] in
            var res: [MarkerEntityProtocol] = []
            for feature in features {
                let marker = self?.convertMGLFeatureToMarkerEntity(source: feature)
                res.append(marker ?? BusstopMarkerEntity())// TODO: Fix later
            }
            return res
        }).drive(onNext: { [weak self] (features) in
            self?.dependency.commonPresenter.visibleFeatureEntity.accept(features)
        }).disposed(by: disposeBag)
        
        /// Dependency injection to CommonPresenter

        dependency.commonPresenter.inject(mapView: input.mapView)
    }
    
    func convertMGLFeatureToMarkerEntity(source: MGLFeature) -> MarkerEntityProtocol {
        let category = dependency.commonPresenter.visibleLayerEntity.value.visibleCategory()        
        return dependency.interactor.createMarkerEntity(
            category: category,
            coordinate: source.coordinate,
            attributes: source.attributes
        )
    }
    
    func sorteFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature] {
        return features.sorted(by: {
            let distanceFromLocationA = CLLocation(latitude: $0.coordinate.latitude,longitude: $0.coordinate.longitude).distance(from: center)
            let distanceFromLocationB = CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: center)
            
            return distanceFromLocationA < distanceFromLocationB
        })
    }
}

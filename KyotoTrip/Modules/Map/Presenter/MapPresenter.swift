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
}

protocol MapPresenterProtocol: AnyObject {
    // MARK: - Properties

    static var layerIdentifiers: Set<String> { get }

    // MARK: - Input to Presenter
    
    func bindMapView(input: MapViewInput)

    // MARK: - Output from Presenter

    var userPositionButtonStatusDriver: Driver<UserPosition> { get }
    var visibleLayerEntityDriver: Driver<VisibleLayerEntity> { get }
    var selectedCategoryViewCellDriver: Driver<VisibleFeatureProtocol> { get }
    var visibleFeatureRestaurantEntityDriver: Driver<[VisibleFeatureProtocol]> { get }
    
    // MARK: - Others
    
    func convertMGLFeatureToVisibleFeature(source: MGLFeature) -> VisibleFeatureProtocol
    func sorteFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature]
    func createRestaurantAnnotation(entity: RestaurantFeatureEntity) -> RestaurantPointAnnotation
}

class MapPresenter: MapPresenterProtocol {
    
    // MARK: - Properties
    struct Dependency {
        let interactor: MapInteractorProtocol
        let commonPresenter: CommonMapPresenterProtocol
    }

    static var layerIdentifiers: Set<String> = [
        BusstopFeatureEntity.layerId,
        CulturalPropertyFeatureEntity.layerId
    ]
    
    var userPositionButtonStatusDriver: Driver<UserPosition> {
        return userPositionButtonStatus.asDriver()
    }
    var visibleLayerEntityDriver: Driver<VisibleLayerEntity> {
        return dependency.commonPresenter.visibleLayerEntity.asDriver()
    }
    var selectedCategoryViewCellDriver: Driver<VisibleFeatureProtocol> {
        return dependency.commonPresenter.selectedCategoryViewCellRelay.asDriver()
    }
    var visibleFeatureRestaurantEntityDriver: Driver<[VisibleFeatureProtocol]> {
        return dependency.commonPresenter.visibleFeatureRestaurantEntity.asDriver()
    }
    
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let userPositionButtonStatus = BehaviorRelay<UserPosition>(value: .kyotoCity)
    
    // MARK: - Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func bindMapView(input: MapViewInput) {        
        input.compassButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextPosition = self.dependency.interactor.updateUserPosition(self.userPositionButtonStatus.value)
            self.userPositionButtonStatus.accept(nextPosition)
        }).disposed(by: disposeBag)
        
        input.features.map({ [weak self] (features) -> [VisibleFeatureProtocol] in
            var res: [VisibleFeatureProtocol] = []
            for feature in features {
                let visibleFeature = self?.convertMGLFeatureToVisibleFeature(source: feature)
                res.append(visibleFeature ?? BusstopFeatureEntity())// TODO: Fix later
            }
            return res
        }).drive(onNext: { [weak self] (features) in
            self?.dependency.commonPresenter.visibleFeatureEntity.accept(features)
        }).disposed(by: disposeBag)
    }
    
    func convertMGLFeatureToVisibleFeature(source: MGLFeature) -> VisibleFeatureProtocol {
        var category: VisibleFeatureCategory {
            if let _ = source.attribute(forKey: BusstopFeatureEntity.titleId) as? String {
                return .Busstop
            } else if let _ = source.attribute(forKey: CulturalPropertyFeatureEntity.titleId) as? String {
                return .CulturalProperty
            }
            return .None
        }
        
        return dependency.interactor.createVisibleFeature(
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
    
    func createRestaurantAnnotation(entity: RestaurantFeatureEntity) -> RestaurantPointAnnotation {
        let annotation = RestaurantPointAnnotation(entity: entity)
        annotation.title = entity.title
        annotation.subtitle = entity.subtitle
        annotation.coordinate = entity.coordinate
        
        return annotation
    }
}

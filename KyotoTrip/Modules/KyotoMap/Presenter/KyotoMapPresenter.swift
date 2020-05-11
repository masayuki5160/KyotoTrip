//
//  MapViewModel.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/21.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Mapbox

struct MapViewInput {
    let compassButton: Driver<Void>
    let features: Driver<[MGLFeature]>
}

struct CategoryViewInput {
    let culturalPropertyButton: Driver<Void>
    let infoButton: Driver<Void>
    let busstopButton: Driver<Void>
    let restaurantButton: Driver<Void>
    let tableViewCell: Driver<VisibleFeatureProtocol>
}

protocol KyotoMapPresenterProtocol: AnyObject {
    // MARK: - Properties

    static var layerIdentifiers: Set<String> { get }

    // MARK: - Input to Presenter
    
    func bindMapView(input: MapViewInput)
    func bindCategoryView(input: CategoryViewInput)

    // MARK: - Output from Presenter

    var userPositionButtonStatusDriver: Driver<UserPosition> { get }
    var visibleLayerDriver: Driver<VisibleLayerEntity> { get }
    var visibleFeatureEntityDriver: Driver<[VisibleFeatureProtocol]> { get }
    var visibleFeatureRestaurantEntityDriver: Driver<[VisibleFeatureProtocol]> { get }
    var didSelectCellDriver: Driver<VisibleFeatureProtocol> { get }
    
    // MARK: - Others
    
    func convertMGLFeatureToVisibleFeature(source: MGLFeature) -> VisibleFeatureProtocol
    func sorteFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature]
    func createRestaurantAnnotation(entity: RestaurantFeatureEntity) -> RestaurantPointAnnotation
}

class KyotoMapPresenter: KyotoMapPresenterProtocol {
    // MARK: - Properties
    struct Dependency {
        let interactor: KyotoMapInteractorProtocol
    }

    static var layerIdentifiers: Set<String> = [
        BusstopFeatureEntity.layerId,
        CulturalPropertyFeatureEntity.layerId
    ]
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let userPositionButtonStatus = BehaviorRelay<UserPosition>(value: .kyotoCity)
    private let visibleFeatureEntity = BehaviorRelay<[VisibleFeatureProtocol]>(value: [])
    private let visibleFeatureRestaurantEntity = BehaviorRelay<[VisibleFeatureProtocol]>(value: [])
    private let visibleLayerEntity = BehaviorRelay<VisibleLayerEntity>(value: VisibleLayerEntity())
    private var didSelectCellEntity = BehaviorRelay<VisibleFeatureProtocol>(value: BusstopFeatureEntity())// TODO: Fix later
    
    var userPositionButtonStatusDriver: Driver<UserPosition> {
        return userPositionButtonStatus.asDriver()
    }
    var visibleFeatureEntityDriver: Driver<[VisibleFeatureProtocol]> {
        return visibleFeatureEntity.asDriver()
    }
    var visibleFeatureRestaurantEntityDriver: Driver<[VisibleFeatureProtocol]> {
        return visibleFeatureRestaurantEntity.asDriver()
    }
    var visibleLayerDriver: Driver<VisibleLayerEntity> {
        return visibleLayerEntity.asDriver()
    }
    var didSelectCellDriver: Driver<VisibleFeatureProtocol> {
        return didSelectCellEntity.asDriver()
    }
    
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
            self?.visibleFeatureEntity.accept(features)
        }).disposed(by: disposeBag)
    }
    
    func bindCategoryView(input: CategoryViewInput) {
        input.culturalPropertyButton.drive(onNext: { [weak self] in
            guard let self = self else { return }

            let nextVisibleLayer = self.dependency.interactor.nextVisibleLayer(
                target: .CulturalProperty,
                current: self.visibleLayerEntity.value
            )
            self.visibleLayerEntity.accept(nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.busstopButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.dependency.interactor.nextVisibleLayer(
                target: .Busstop,
                current: self.visibleLayerEntity.value
            )
            self.visibleLayerEntity.accept(nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.restaurantButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            // TODO: アプリで設定された条件でレストラン検索(Gateway改修しInteractorからコール)
            self.dependency.interactor.fetchRestaurantData { (response) in
                switch response {
                case .success(let data):
                    var res: [RestaurantFeatureEntity] = []
                    for restaurant in data.rest {
                        let restaurant = self.dependency.interactor.createRestaurantVisibleFeature(source: restaurant)
                        res.append(restaurant)
                    }
                    
                    self.visibleFeatureRestaurantEntity.accept(res)
                case .failure(let error):
                    print(error)
                }
            }
            
            let nextVisibleLayer = self.dependency.interactor.nextVisibleLayer(
                target: .Restaurant,
                current: self.visibleLayerEntity.value
            )
            self.visibleLayerEntity.accept(nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.tableViewCell.drive(onNext: { [weak self] (feature) in
            self?.didSelectCellEntity.accept(feature)
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

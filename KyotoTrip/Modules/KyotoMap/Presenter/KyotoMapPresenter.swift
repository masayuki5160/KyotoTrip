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

struct CategoryViewInput {
    let culturalPropertyButton: Driver<Void>
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
    var visibleLayerEntityDriver: Driver<VisibleLayerEntity> { get }
    var visibleFeatureEntityDriver: Driver<[VisibleFeatureProtocol]> { get }
    var visibleFeatureRestaurantEntityDriver: Driver<[VisibleFeatureProtocol]> { get }
    var didSelectCellEntityDriver: Driver<VisibleFeatureProtocol> { get }
    
    // MARK: - Others
    
    func convertMGLFeatureToVisibleFeature(source: MGLFeature) -> VisibleFeatureProtocol
    func sorteFeatures(features: [MGLFeature], center: CLLocation) -> [MGLFeature]
    func createRestaurantAnnotation(entity: RestaurantFeatureEntity) -> RestaurantPointAnnotation
    func categoryTableViewCellIconName(_ category: VisibleFeatureCategory) -> String
}

class KyotoMapPresenter: KyotoMapPresenterProtocol {
    // MARK: - Properties
    struct Dependency {
        let interactor: KyotoMapInteractorProtocol
        let mapView: MapViewProtocol
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
    var visibleLayerEntityDriver: Driver<VisibleLayerEntity> {
        return visibleLayerEntity.asDriver()
    }
    var didSelectCellEntityDriver: Driver<VisibleFeatureProtocol> {
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
            
            let nextVisibleLayer = self.dependency.interactor.nextVisibleLayer(
                target: .Restaurant,
                current: self.visibleLayerEntity.value
            )
            
            switch nextVisibleLayer.restaurant {
            case .hidden:
                self.visibleFeatureRestaurantEntity.accept([])
            case .visible:
                self.fetchRestaurantsEntity()
            }
            
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
    
    func categoryTableViewCellIconName(_ category: VisibleFeatureCategory) -> String {
        let iconName: String
        switch category {
        case .Busstop:
            iconName = CategoryTableViewCell.IconName.busstop
        case .CulturalProperty:
            iconName = CategoryTableViewCell.IconName.culturalProperty
        case .Restaurant:
            iconName = CategoryTableViewCell.IconName.restaurant
        default:
            // TODO: Set default icon name
            iconName = CategoryTableViewCell.IconName.busstop
        }
        
        return iconName
    }
}

private extension KyotoMapPresenter {
    func fetchRestaurantsEntity() {
        let mapView = dependency.mapView.mapView as MGLMapView

        dependency.interactor.fetchRestaurants(location: mapView.centerCoordinate) { [weak self] (response) in
            guard let self = self else { return }

            switch response {
            case .success(let restaurantsSearchResultEntity):
                var restaurantFeatures: [RestaurantFeatureEntity] = []
                for restaurant in restaurantsSearchResultEntity.rest {
                    let featureEntity = self.dependency.interactor.createRestaurantVisibleFeature(source: restaurant)
                    restaurantFeatures.append(featureEntity)
                }
                
                self.visibleFeatureRestaurantEntity.accept(restaurantFeatures)
            case .failure(let error):
                switch error {
                case .entryNotFound:
                    // TODO: View側にレストラン検索結果が0件だったことを通知
                    print("Error: No entory found")
                case .otherError:
                    print("Error: some error occured")
                }
                
                self.visibleFeatureRestaurantEntity.accept([])
            }
        }
    }
}

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
    let rentalCycleButton: Driver<Void>
    let cycleParkingButton: Driver<Void>
    let tableViewCell: Driver<VisibleFeatureProtocol>
}

protocol KyotoMapPresenterProtocol: AnyObject {
    static var layerIdentifiers: Set<String> { get }
    var userPositionButtonStatusDriver: Driver<UserPosition> { get }
    var visibleLayerDriver: Driver<VisibleLayer> { get }
    var visibleFeatureDriver: Driver<[VisibleFeatureProtocol]> { get }
    var didSelectCellDriver: Driver<VisibleFeatureProtocol> { get }
    func bindMapView(input: MapViewInput)
    func bindCategoryView(input: CategoryViewInput)
    func convertMGLFeatureToVisibleFeature(source: MGLFeature) -> VisibleFeatureProtocol
}

class KyotoMapPresenter: KyotoMapPresenterProtocol {
    // MARK: - Properties
    struct Dependency {
        let interactor: KyotoMapInteractorProtocol
    }

    static var layerIdentifiers: Set<String> = [
        KyotoMapView.busstopLayerName,
        KyotoMapView.busRouteLayerName,
        KyotoMapView.culturalPropertyLayerName
    ]
    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let userPositionButtonStatusBehaviorRelay = BehaviorRelay<UserPosition>(value: .kyotoCity)
    private let visibleFeatureBehaviorRelay = BehaviorRelay<[VisibleFeatureProtocol]>(value: [])
    private let visibleLayerBehaviorRelay = BehaviorRelay<VisibleLayer>(value: VisibleLayer())
    private var didSelectCellBehaviorRelay = BehaviorRelay<VisibleFeatureProtocol>(value: BusstopFeature())// TODO: Fix later
    
    var userPositionButtonStatusDriver: Driver<UserPosition> {
        return userPositionButtonStatusBehaviorRelay.asDriver()
    }
    var visibleFeatureDriver: Driver<[VisibleFeatureProtocol]> {
        return visibleFeatureBehaviorRelay.asDriver()
    }
    var visibleLayerDriver: Driver<VisibleLayer> {
        return visibleLayerBehaviorRelay.asDriver()
    }
    var didSelectCellDriver: Driver<VisibleFeatureProtocol> {
        return didSelectCellBehaviorRelay.asDriver()
    }
    
    // MARK: - Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func bindMapView(input: MapViewInput) {        
        input.compassButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextPosition = self.dependency.interactor.updateUserPosition(self.userPositionButtonStatusBehaviorRelay.value)
            self.userPositionButtonStatusBehaviorRelay.accept(nextPosition)
        }).disposed(by: disposeBag)
        
        input.features.map({ [weak self] (features) -> [VisibleFeatureProtocol] in
            var res: [VisibleFeatureProtocol] = []
            for feature in features {
                let visibleFeature = self?.convertMGLFeatureToVisibleFeature(source: feature)
                res.append(visibleFeature ?? BusstopFeature())// TODO: Fix later
            }
            return res
        }).drive(onNext: { [weak self] (features) in
            self?.visibleFeatureBehaviorRelay.accept(features)
        }).disposed(by: disposeBag)
    }
    
    func bindCategoryView(input: CategoryViewInput) {
        input.culturalPropertyButton.drive(onNext: { [weak self] in
            guard let self = self else { return }

            let nextVisibleLayer = self.updateLayer(target: .CulturalProperty, layer: self.visibleLayerBehaviorRelay.value)
            self.visibleLayerBehaviorRelay.accept(nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.busstopButton.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            let nextVisibleLayer = self.updateLayer(target: .Busstop, layer: self.visibleLayerBehaviorRelay.value)
            self.visibleLayerBehaviorRelay.accept(nextVisibleLayer)
        }).disposed(by: disposeBag)
        
        input.tableViewCell.drive(onNext: { [weak self] (feature) in
            self?.didSelectCellBehaviorRelay.accept(feature)
        }).disposed(by: disposeBag)
    }
    
    func convertMGLFeatureToVisibleFeature(source: MGLFeature) -> VisibleFeatureProtocol {
        var category: VisibleFeatureCategory {
            if let _ = source.attribute(forKey: BusstopFeature.titleId) as? String {
                return .Busstop
            } else if let _ = source.attribute(forKey: CulturalPropertyFeature.titleId) as? String {
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
    
    // MARK: - Private functions
    
    private func updateLayer(target: VisibleFeatureCategory, layer: VisibleLayer) -> VisibleLayer {
        switch target {
        case .Busstop:
            return dependency.interactor.updateBusstopLayer(layer)
        case .CulturalProperty:
            return dependency.interactor.updateCulturalPropertylayer(layer)
        default:
            return VisibleLayer()
        }
    }
}

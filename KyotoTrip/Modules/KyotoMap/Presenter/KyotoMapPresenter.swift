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
    
    // MARK: - Output IF
    
    var userPositionButtonStatusDriver: Driver<UserPosition> { get }
    var visibleLayerDriver: Driver<VisibleLayer> { get }
    var visibleFeatureDriver: Driver<[VisibleFeatureProtocol]> { get }
    var didSelectCellDriver: Driver<VisibleFeatureProtocol> { get }
    
    // MARK: - Input IF
    
    func bindMapView(input: MapViewInput)
    func bindCategoryView(input: CategoryViewInput)
}

class KyotoMapPresenter: KyotoMapPresenterProtocol {
    
    // MARK: - Properties
    
    struct Dependency {
        let interactor: KyotoMapInteractorProtocol
    }

    private var dependency: Dependency!
    private let disposeBag = DisposeBag()
    private let userPositionButtonStatusBehaviorRelay = BehaviorRelay<UserPosition>(value: .kyotoCity)
    private let visibleFeatureBehaviorRelay = BehaviorRelay<[VisibleFeatureProtocol]>(value: [])
    private let visibleLayerBehaviorRelay = BehaviorRelay<VisibleLayer>(value: VisibleLayer(
        busstop: .hidden,
        culturalProperty: .hidden,
        info: .hidden,
        rentalCycle: .hidden,
        cycleParking: .hidden)
    )
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
    
    // TODO: 判定処理が多く煩雑なため後で修正する
    private func convertMGLFeatureToVisibleFeature(source: MGLFeature) -> VisibleFeatureProtocol {
        if let title = source.attribute(forKey: BusstopFeature.titleId) as? String {
            let subtitle = "busstop"// TODO: Fix later
            let coordinate = source.coordinate
            return BusstopFeature(
                title: title,
                subtitle: subtitle,
                coordinate: coordinate,
                type: .Busstop
            )
        } else if let title = source.attribute(forKey: CulturalPropertyFeature.titleId) as? String {
            let subtitle = "culturalProperty"// TODO: Fix later
            let coordinate = source.coordinate
            return CulturalPropertyFeature(
                title: title,
                subtitle: subtitle,
                coordinate: coordinate,
                type: .CulturalProperty
            )
        }
        
        // TODO: Fix later
        return BusstopFeature()
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
    
    // MARK: - Private functions
    
    private func updateLayer(target: VisibleFeatureCategory, layer: VisibleLayer) -> VisibleLayer {
        switch target {
        case .Busstop:
            return dependency.interactor.updateBusstopLayer(layer)
        case .CulturalProperty:
            return dependency.interactor.updateCulturalPropertylayer(layer)
        default:
            return VisibleLayer(
                busstop: .hidden,
                culturalProperty: .hidden,
                info: .hidden,
                rentalCycle: .hidden,
                cycleParking: .hidden
            )
        }
    }
}

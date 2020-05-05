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

enum CompassButtonStatus: Int {
    case kyotoCity = 0
    case currentLocation
}

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
    let tableViewCell: Driver<VisibleFeature>
}

protocol KyotoMapPresenterProtocol: AnyObject {
    
    // MARK: - Output IF
    
    var compassButtonStatusDriver: Driver<CompassButtonStatus> { get }
    var visibleLayerDriver: Driver<VisibleLayer> { get }
    var visibleFeatureDriver: Driver<[VisibleFeature]> { get }
    var didSelectCellDriver: Driver<VisibleFeature> { get }
    
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
    private let compassButtonStatusBehaviorRelay = BehaviorRelay<CompassButtonStatus>(value: .kyotoCity)
    private let visibleFeatureBehaviorRelay = BehaviorRelay<[VisibleFeature]>(value: [])
    private let visibleLayerBehaviorRelay = BehaviorRelay<VisibleLayer>(value: VisibleLayer(
        busstop: .hidden,
        culturalProperty: .hidden,
        info: .hidden,
        rentalCycle: .hidden,
        cycleParking: .hidden)
    )
    private var didSelectCellBehaviorRelay = BehaviorRelay<VisibleFeature>(value: VisibleFeature())
    
    var compassButtonStatusDriver: Driver<CompassButtonStatus> {
        return compassButtonStatusBehaviorRelay.asDriver()
    }
    var visibleFeatureDriver: Driver<[VisibleFeature]> {
        return visibleFeatureBehaviorRelay.asDriver()
    }
    var visibleLayerDriver: Driver<VisibleLayer> {
        return visibleLayerBehaviorRelay.asDriver()
    }
    var didSelectCellDriver: Driver<VisibleFeature> {
        return didSelectCellBehaviorRelay.asDriver()
    }
    
    // MARK: - Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func bindMapView(input: MapViewInput) {        
        input.compassButton.drive(onNext: { [weak self] in
            self?.updateCompassButtonStatus()
        }).disposed(by: disposeBag)
        
        input.features.map({ (features) -> [VisibleFeature] in
            var res: [VisibleFeature] = []
            for feature in features {
                var visibleFeature = VisibleFeature()

                // TODO: データのマッピング処理を再度実装
                if let title = feature.attribute(forKey: "P11_001") as? String {
                    visibleFeature.title = title
                    visibleFeature.type = .Busstop
                } else if let title = feature.attribute(forKey: "P32_006") as? String {
                    visibleFeature.title = title
                    visibleFeature.type = .CulturalProperty
                } else if let title = feature.attribute(forKey: "N07_003") as? String {
                    // TODO: キーがなぜか確認できない
                    visibleFeature.title = title
                    visibleFeature.type = .BusRoute
                } else {
                    visibleFeature.title = "NULL"
                    visibleFeature.type = .None
                }
                
                visibleFeature.coordinate = feature.coordinate
                
                res.append(visibleFeature)
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
    
    // MARK: - Private functions
    
    private func updateLayer(target: VisibleFeature.Category, layer: VisibleLayer) -> VisibleLayer {
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
    
    private func updateCompassButtonStatus() {
        let nextStatusRawValue = self.compassButtonStatusBehaviorRelay.value.rawValue + 1
        let nextStatus = CompassButtonStatus(rawValue: nextStatusRawValue) ?? CompassButtonStatus.kyotoCity
        
        self.compassButtonStatusBehaviorRelay.accept(nextStatus)
    }
}

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

enum VisibleLayerStatus: Int {
    case hidden = 0
    case visible
}

struct MapViewInput {
    let busstopButton: Observable<Void>
    let compassButton: Observable<Void>
    let features: Observable<[MGLFeature]>
}

struct CategoryViewInput {
    let culturalPropertyButton: Observable<Void>
    let infoButton: Observable<Void>
    let busstopButton: Observable<Void>
    let rentalCycleButton: Observable<Void>
    let cycleParkingButton: Observable<Void>
}

struct VisibleLayer {
    let busstopLayer: VisibleLayerStatus
    let culturalPropertyLayer: VisibleLayerStatus
    let infoLayer: VisibleLayerStatus
    let rentalCycle: VisibleLayerStatus
    let cycleParking: VisibleLayerStatus
}

protocol KyotoMapPresenterProtocol: AnyObject {
    
    // MARK: - Output IF
    
    var compassButtonStatusDriver: Driver<CompassButtonStatus> { get }
    var visibleLayerDriver: Driver<VisibleLayer> { get }
    var visibleFeatureDriver: Driver<[VisibleFeature]> { get }
    
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
        busstopLayer: .hidden,
        culturalPropertyLayer: .hidden,
        infoLayer: .hidden,
        rentalCycle: .hidden,
        cycleParking: .hidden)
    )
    
    var compassButtonStatusDriver: Driver<CompassButtonStatus> {
        return compassButtonStatusBehaviorRelay.asDriver()
    }
    var visibleFeatureDriver: Driver<[VisibleFeature]> {
        return visibleFeatureBehaviorRelay.asDriver()
    }
    var visibleLayerDriver: Driver<VisibleLayer> {
        return visibleLayerBehaviorRelay.asDriver()
    }
    
    // MARK: - Public functions
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func bindMapView(input: MapViewInput) {
        input.busstopButton.subscribe(onNext: { [weak self] in
            self?.updateBusstopButtonStatus()
        }).disposed(by: disposeBag)
        
        input.compassButton.subscribe(onNext: { [weak self] in
            self?.updateCompassButtonStatus()
        }).disposed(by: disposeBag)
        
        input.features.map({ (features) -> [VisibleFeature] in
            var res: [VisibleFeature] = []
            for feature in features {
                var tmpFeature = VisibleFeature()

                // TODO: データのマッピング処理を再度実装
                if let title = feature.attribute(forKey: "P11_001") as? String {
                    tmpFeature.title = "[BUSSTOP]\(title)"
                } else if let title = feature.attribute(forKey: "P32_006") as? String {
                    tmpFeature.title = "[CULTURAL]\(title)"
                } else if let title = feature.attribute(forKey: "N07_003") as? String {
                    // TODO: キーがなぜか確認できない
                    tmpFeature.title = "[BUS ROUTE]\(title)"
                } else {
                    tmpFeature.title = "NULL"
                }
                
                res.append(tmpFeature)
            }
            
            return res
        }).share().subscribe(onNext: { [weak self] (features) in
            self?.visibleFeatureBehaviorRelay.accept(features)
        }).disposed(by: disposeBag)
    }
    
    func bindCategoryView(input: CategoryViewInput) {
        input.culturalPropertyButton.subscribe(onNext: { [weak self] in
            self?.updateCulturalPropertyButtonStatus()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Private functions
    
    private func updateCulturalPropertyButtonStatus() {
        let currentVisibleLayer = visibleLayerBehaviorRelay.value
        let nextStatusRawValue = currentVisibleLayer.culturalPropertyLayer.rawValue + 1
        let nextStatus = VisibleLayerStatus(rawValue: nextStatusRawValue) ?? VisibleLayerStatus.hidden
        let nextVisibleLayer = VisibleLayer(busstopLayer: currentVisibleLayer.busstopLayer,
                                culturalPropertyLayer: nextStatus,
                                infoLayer: currentVisibleLayer.infoLayer,
                                rentalCycle: currentVisibleLayer.rentalCycle,
                                cycleParking: currentVisibleLayer.cycleParking)

        visibleLayerBehaviorRelay.accept(nextVisibleLayer)
    }
    
    private func updateBusstopButtonStatus() {
        let currentVisibleLayer = visibleLayerBehaviorRelay.value
        let nextStatusRawValue = currentVisibleLayer.busstopLayer.rawValue + 1
        let nextStatus = VisibleLayerStatus(rawValue: nextStatusRawValue) ?? VisibleLayerStatus.hidden
        let nextVisibleLayer = VisibleLayer(busstopLayer: nextStatus,
                                            culturalPropertyLayer: currentVisibleLayer.culturalPropertyLayer,
                                infoLayer: currentVisibleLayer.infoLayer,
                                rentalCycle: currentVisibleLayer.rentalCycle,
                                cycleParking: currentVisibleLayer.cycleParking)

        visibleLayerBehaviorRelay.accept(nextVisibleLayer)
    }
    
    private func updateCompassButtonStatus() {
        let nextStatusRawValue = self.compassButtonStatusBehaviorRelay.value.rawValue + 1
        let nextStatus = CompassButtonStatus(rawValue: nextStatusRawValue) ?? CompassButtonStatus.kyotoCity
        
        self.compassButtonStatusBehaviorRelay.accept(nextStatus)
    }
}

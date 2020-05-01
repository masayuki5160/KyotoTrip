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

enum BusstopButtonStatus: Int {
    case hidden = 0
    case busstop
    case routeAndBusstop
}

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
}

protocol KyotoMapPresenterProtocol: AnyObject {
    var busstopButtonStatusDriver: Driver<BusstopButtonStatus> { get }
    var compassButtonStatusDriver: Driver<CompassButtonStatus> { get }
    var culturalPropertyButtonStatusDriver: Driver<VisibleLayerStatus> { get }
    var visibleFeatureDriver: Driver<[VisibleFeature]> { get }
    
    func bindMapView(input: MapViewInput)
    func bindCategoryView(input: CategoryViewInput)
}

class KyotoMapPresenter: KyotoMapPresenterProtocol {
    
    struct Dependency {
        let interactor: KyotoMapInteractorProtocol
    }

    private var dependency: Dependency!
    private let busstopButtonStatusBehaviorRelay = BehaviorRelay<BusstopButtonStatus>(value: .hidden)
    private let compassButtonStatusBehaviorRelay = BehaviorRelay<CompassButtonStatus>(value: .kyotoCity)
    private let culturalPropertyButtonStatusBehaviorRelay = BehaviorRelay<VisibleLayerStatus>(value: .hidden)
    private let visibleFeatureBehaviorRelay = BehaviorRelay<[VisibleFeature]>(value: [])
    var busstopButtonStatusDriver: Driver<BusstopButtonStatus> {
        return busstopButtonStatusBehaviorRelay.asDriver()
    }
    var compassButtonStatusDriver: Driver<CompassButtonStatus> {
        return compassButtonStatusBehaviorRelay.asDriver()
    }
    var culturalPropertyButtonStatusDriver: Driver<VisibleLayerStatus> {
        return culturalPropertyButtonStatusBehaviorRelay.asDriver()
    }
    var visibleFeatureDriver: Driver<[VisibleFeature]> {
        return visibleFeatureBehaviorRelay.asDriver()
    }

    private let disposeBag = DisposeBag()
    
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
    
    private func updateCulturalPropertyButtonStatus() {
        let nextStatusRawValue = self.culturalPropertyButtonStatusBehaviorRelay.value.rawValue + 1
        let nextStatus = VisibleLayerStatus(rawValue: nextStatusRawValue) ?? VisibleLayerStatus.hidden
        
        self.culturalPropertyButtonStatusBehaviorRelay.accept(nextStatus)
    }
    
    private func updateBusstopButtonStatus() {
        let nextStatusRawValue = self.busstopButtonStatusBehaviorRelay.value.rawValue + 1
        let nextStatus = BusstopButtonStatus(rawValue: nextStatusRawValue) ?? BusstopButtonStatus.hidden
        
        self.busstopButtonStatusBehaviorRelay.accept(nextStatus)
    }
    
    private func updateCompassButtonStatus() {
        let nextStatusRawValue = self.compassButtonStatusBehaviorRelay.value.rawValue + 1
        let nextStatus = CompassButtonStatus(rawValue: nextStatusRawValue) ?? CompassButtonStatus.kyotoCity
        
        self.compassButtonStatusBehaviorRelay.accept(nextStatus)
    }
}

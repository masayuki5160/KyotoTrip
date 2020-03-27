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

enum BusstopButtonStatus: Int {
    case hidden = 0
    case busstop
    case routeAndBusstop
}

enum CompassButtonStatus: Int {
    case kyotoCity = 0
    case currentLocation
}

class MapViewModel {
    
    private var busstopButtonStatus = BusstopButtonStatus.hidden
    private let busstopButtonStatusBehaviorRelay = BehaviorRelay<BusstopButtonStatus>(value: .hidden)
    var busstopButtonStatusDriver: Driver<BusstopButtonStatus> {
        return busstopButtonStatusBehaviorRelay.asDriver()
    }
    
    private var compassButtonStatus = CompassButtonStatus.kyotoCity
    private let compassButtonStatusBehaviorRelay = BehaviorRelay<CompassButtonStatus>(value: .kyotoCity)
    var compassButtonStatusObservable: Driver<CompassButtonStatus> {
        return compassButtonStatusBehaviorRelay.asDriver()
    }
    
    let disposeBag = DisposeBag()
    
    init(busstopButton: Observable<Void>, compassButton: Observable<Void>) {
        
        busstopButton.subscribe(onNext: { [weak self] in
            self?.updateBusstopButtonStatus()
        }).disposed(by: disposeBag)
        
        compassButton.subscribe(onNext: { [weak self] in
            self?.updateCompassButtonStatus()
        }).disposed(by: disposeBag)
        
    }
    
    private func updateBusstopButtonStatus() {
        let nextStatusRawValue = self.busstopButtonStatus.rawValue + 1
        self.busstopButtonStatus = BusstopButtonStatus(rawValue: nextStatusRawValue) ?? BusstopButtonStatus.hidden
        
        self.busstopButtonStatusBehaviorRelay.accept(self.busstopButtonStatus)
    }
    
    private func updateCompassButtonStatus() {
        let nextStatusRawValue = self.compassButtonStatus.rawValue + 1
        self.compassButtonStatus = CompassButtonStatus(rawValue: nextStatusRawValue) ?? CompassButtonStatus.kyotoCity
        
        self.compassButtonStatusBehaviorRelay.accept(self.compassButtonStatus)
    }
}

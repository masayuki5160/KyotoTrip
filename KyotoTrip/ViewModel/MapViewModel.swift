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
    private let busstopButtonStatusPublishRelay = PublishRelay<BusstopButtonStatus>()
    var busstopButtonStatusObservable: Observable<BusstopButtonStatus> {
        return busstopButtonStatusPublishRelay.asObservable()
    }
    
    private var compassButtonStatus = CompassButtonStatus.kyotoCity
    private let compassButtonStatusPublishRelay = PublishRelay<CompassButtonStatus>()
    var compassButtonStatusObservable: Observable<CompassButtonStatus> {
        return compassButtonStatusPublishRelay.asObservable()
    }
    
    let disposeBag = DisposeBag()
    
    init(busstopButtonObservable: Observable<Void>, compassButtonObservable: Observable<Void>) {
        
        busstopButtonObservable.subscribe { [weak self] (_) in

            let nextStatusRawValue = (self?.busstopButtonStatus.rawValue ?? 0) + 1
            self?.busstopButtonStatus = BusstopButtonStatus(rawValue: nextStatusRawValue) ?? BusstopButtonStatus.hidden
            
            self?.busstopButtonStatusPublishRelay.accept(self?.busstopButtonStatus ?? BusstopButtonStatus.hidden)
            
        }.disposed(by: disposeBag)
        
        compassButtonObservable.subscribe { [weak self] (_) in

            let nextStatusRawValue = (self?.compassButtonStatus.rawValue ?? 0) + 1
            self?.compassButtonStatus = CompassButtonStatus(rawValue: nextStatusRawValue) ?? CompassButtonStatus.kyotoCity
            
            self?.compassButtonStatusPublishRelay.accept(self?.compassButtonStatus ?? CompassButtonStatus.kyotoCity)
            
        }.disposed(by: disposeBag)
        
    }
}

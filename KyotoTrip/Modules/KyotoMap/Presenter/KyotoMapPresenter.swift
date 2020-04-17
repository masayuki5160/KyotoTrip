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

protocol KyotoMapPresenterProtocol: AnyObject {
    var busstopButtonStatusDriver: Driver<BusstopButtonStatus> { get }
    var compassButtonStatusDriver: Driver<CompassButtonStatus> { get }
}

class KyotoMapPresenter: KyotoMapPresenterProtocol {
    
    private let busstopButtonStatusBehaviorRelay = BehaviorRelay<BusstopButtonStatus>(value: .hidden)
    var busstopButtonStatusDriver: Driver<BusstopButtonStatus> {
        return busstopButtonStatusBehaviorRelay.asDriver()
    }
    
    private let compassButtonStatusBehaviorRelay = BehaviorRelay<CompassButtonStatus>(value: .kyotoCity)
    var compassButtonStatusDriver: Driver<CompassButtonStatus> {
        return compassButtonStatusBehaviorRelay.asDriver()
    }
    
    let disposeBag = DisposeBag()
    
    struct Dependency {
        let interactor: KyotoMapInteractorProtocol
    }
    private var dependency: Dependency!
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // TODO: 他に良い方法がないかあとで確認する(setup()みたいなものにまとめる？)
    func subscribeButtonTapEvent(busstopButton: Observable<Void>, compassButton: Observable<Void>) {
        busstopButton.subscribe(onNext: { [weak self] in
            self?.updateBusstopButtonStatus()
        }).disposed(by: disposeBag)
        
        compassButton.subscribe(onNext: { [weak self] in
            self?.updateCompassButtonStatus()
        }).disposed(by: disposeBag)
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

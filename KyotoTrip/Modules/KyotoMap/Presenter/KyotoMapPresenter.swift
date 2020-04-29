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
    var categoryButtonStatusDriver: Driver<BusstopButtonStatus> { get }
    
    func bindButtonTapEvent(busstopButton: Observable<Void>, compassButton: Observable<Void>)
    func bindCategoryButtonTapEvent(button: Observable<Void>)
}

class KyotoMapPresenter: KyotoMapPresenterProtocol {
    
    struct Dependency {
        let interactor: KyotoMapInteractorProtocol
    }
    private var dependency: Dependency!
    
    private let busstopButtonStatusBehaviorRelay = BehaviorRelay<BusstopButtonStatus>(value: .hidden)
    private let compassButtonStatusBehaviorRelay = BehaviorRelay<CompassButtonStatus>(value: .kyotoCity)
    private let categoryButtonStatusBehaviorRelay = BehaviorRelay<BusstopButtonStatus>(value: .hidden)// TODO: Fix later
    var busstopButtonStatusDriver: Driver<BusstopButtonStatus> {
        return busstopButtonStatusBehaviorRelay.asDriver()
    }
    var compassButtonStatusDriver: Driver<CompassButtonStatus> {
        return compassButtonStatusBehaviorRelay.asDriver()
    }
    var categoryButtonStatusDriver: Driver<BusstopButtonStatus> {
        return categoryButtonStatusBehaviorRelay.asDriver()
    }
    private let disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func bindButtonTapEvent(busstopButton: Observable<Void>, compassButton: Observable<Void>) {
        busstopButton.subscribe(onNext: { [weak self] in
            self?.updateBusstopButtonStatus()
        }).disposed(by: disposeBag)
        
        compassButton.subscribe(onNext: { [weak self] in
            self?.updateCompassButtonStatus()
        }).disposed(by: disposeBag)
    }
    
    // TODO: Fix later
    func bindCategoryButtonTapEvent(button: Observable<Void>) {
        button.subscribe(onNext: { [weak self] in
            self?.categoryButtonStatusBehaviorRelay.accept(.busstop)
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

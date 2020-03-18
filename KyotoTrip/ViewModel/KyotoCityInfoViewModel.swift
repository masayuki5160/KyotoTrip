//
//  KyotoCityInfoViewModel.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/14.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KyotoCityInfoViewModel {
    
    private let publishRelay = PublishRelay<[InfoTopPageTableViewCell]>()
    var subscribable: Observable<[InfoTopPageTableViewCell]> {
        return publishRelay.asObservable()
    }
    var disposeBag = DisposeBag()
    
//    init(_ model :Observable<[KyotoCityInfoModel]>) {
    init() {
    }
    
    public func update() {
        // TEST
        self.publishRelay.accept([InfoTopPageTableViewCell(),InfoTopPageTableViewCell()])
    }
}

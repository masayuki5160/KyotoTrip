//
//  KyotoInfoPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol KyotoCityInfoPresenterProtocol: AnyObject {
    func fetch()
    
    // TODO: あとで修正
    var subscribableModelList: Observable<[KyotoCityInfo]> { get }
}

class KyotoCityInfoPresenter: KyotoCityInfoPresenterProtocol {
    var subscribableModelList: Observable<[KyotoCityInfo]>

    struct Dependency {
        let interactor: KyotoCityInfoInteractorProtocol
    }
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        subscribableModelList = self.dependency.interactor.subscribableModelList// TODO: 問題ないかあとで確認
    }
    
    func fetch() {
        dependency.interactor.fetch()
    }

}

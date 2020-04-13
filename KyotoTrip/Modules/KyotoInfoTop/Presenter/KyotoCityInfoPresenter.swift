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
    // TODO: あとでDriveに修正？
    var subscribableModelList: Observable<[KyotoCityInfo]> { get }
}

class KyotoCityInfoPresenter: KyotoCityInfoPresenterProtocol {
    private let modelListPublishRelay = PublishRelay<[KyotoCityInfo]>()
    var subscribableModelList: Observable<[KyotoCityInfo]> {
        return modelListPublishRelay.asObservable()
    }
    struct Dependency {
        let interactor: KyotoCityInfoInteractorProtocol
    }
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func fetch() {
        dependency.interactor.fetch { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                self.modelListPublishRelay.accept([])
            case .success(let data):
                self.modelListPublishRelay.accept(data)
            }
        }
    }

}

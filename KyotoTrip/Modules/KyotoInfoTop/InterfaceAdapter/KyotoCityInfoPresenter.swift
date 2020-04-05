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
    
    private weak var useCase: KyotoCityInfoUseCaseProtocol!
    
    init(useCase: KyotoCityInfoUseCaseProtocol) {
        self.useCase = useCase
        
        // TODO: UseCaseではPresenterを意識して処理をしないため、Presenter側ではViewに依存しないが表示する情報を整理する
        self.subscribableModelList = useCase.subscribableModelList
    }
    
    func fetch() {
        useCase.fetch()
    }

}

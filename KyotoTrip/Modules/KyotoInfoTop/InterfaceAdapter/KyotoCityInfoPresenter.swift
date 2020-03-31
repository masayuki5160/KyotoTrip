//
//  KyotoInfoPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

protocol KyotoCityInfoPresenterProtocol: AnyObject {
    func fetch()
    var kyotoCityInfoPresenterOutput: KyotoCityInfoPresenterOutput? { get set }
}

protocol KyotoCityInfoPresenterOutput {
    // TODO: あとで修正(Subscrivableで渡せばいい？)
    func update()
}

class KyotoCityInfoPresenter: KyotoCityInfoPresenterProtocol, KyotoCityInfoUseCaseOutput {
    
    private weak var useCase: KyotoCityInfoUseCaseProtocol!
    var kyotoCityInfoPresenterOutput: KyotoCityInfoPresenterOutput?
    
    init(useCase: KyotoCityInfoUseCaseProtocol) {
        self.useCase = useCase
        self.useCase.output = self
    }
    
    func fetch() {
        // TODO: UseCaseに京都市の情報を取得する処理を依頼
        useCase.fetch()
    }
    
    // KyotoCityInfoUseCaseOutput
    func useCaseDidFetchKyotoCityInfo(_ infoList: KyotoCityInfoList) {
        // TODO: UseCaseからもらったデータをViewに渡して反映させる
        self.kyotoCityInfoPresenterOutput?.update()
    }
}

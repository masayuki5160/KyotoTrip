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
    // var kyotoCityInfoPresenterOutput: KyotoCityInfoPresenterOutput? { get set }
    
    // TODO:  KyotoCityInfoPresenterOutputでなくていい？
    var subscribableModelList: Observable<[KyotoCityInfo]> { get }
}

// CleanArchitectureはoutputが必要だが非同期でのやり取りが可能であれば必須ではないと判断
protocol KyotoCityInfoPresenterOutput {
    // TODO: あとで修正(Subscrivableで渡せばいい？)
    // func update()
//    var subscribableModelList: Observable<[KyotoCityInfo]> { get }
}

//class KyotoCityInfoPresenter: KyotoCityInfoPresenterProtocol, KyotoCityInfoUseCaseOutput {
class KyotoCityInfoPresenter: KyotoCityInfoPresenterProtocol {
    var subscribableModelList: Observable<[KyotoCityInfo]>
    
    private weak var useCase: KyotoCityInfoUseCaseProtocol!
//    var kyotoCityInfoPresenterOutput: KyotoCityInfoPresenterOutput?
    
    init(useCase: KyotoCityInfoUseCaseProtocol) {
        self.useCase = useCase
        // self.useCase.output = self
        
        self.subscribableModelList = useCase.subscribableModelList// TODO: これでいい？
    }
    
    func fetch() {
        useCase.fetch()
        // TODO: View側にuseCase.subscribableModelListを渡してやる？
        
    }
    
    // KyotoCityInfoUseCaseOutput
//    func useCaseDidFetchKyotoCityInfo(_ infoList: KyotoCityInfoList) {
//        // TODO: UseCaseからもらったデータをViewに渡して反映させる
//        self.kyotoCityInfoPresenterOutput?.update()
//    }
}

//
//  KyotoInfoUseCase.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

protocol KyotoCityInfoUseCaseProtocol: AnyObject {
    func fetch()
    var output: KyotoCityInfoUseCaseOutput! { get set }
    var kyotoCityInfoGateway: KyotoCityInfoGatewayProtocol! { get set }
}

protocol KyotoCityInfoUseCaseOutput {
    // TODO: このメソッドはこの実装でいいのか再度確認する
    func useCaseDidFetchKyotoCityInfo(_ infoList: KyotoCityInfoList)
}

protocol KyotoCityInfoGatewayProtocol {
    
}

final class KyotoCityInfoUseCase: KyotoCityInfoUseCaseProtocol {
    
    var output: KyotoCityInfoUseCaseOutput!
    var kyotoCityInfoGateway: KyotoCityInfoGatewayProtocol!
    
    func fetch() {
        // TODO: 京都市のAPI経由でデータを集めてくる
        // TODO: Kyotoというワードがなんども出てきて不要なので変数名などはあとで修正
        let dummyInfo = [KyotoCityInfo()]
        self.output.useCaseDidFetchKyotoCityInfo(KyotoCityInfoList(kyotoCityInfoList: dummyInfo))
    }
}

//
//  KyotoInfoUseCase.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyXMLParser
import Alamofire

protocol KyotoCityInfoUseCaseProtocol: AnyObject {
    func fetch()
    // var output: KyotoCityInfoUseCaseOutput! { get set }
    // var kyotoCityInfoGateway: KyotoCityInfoGatewayProtocol! { get set } // TODO: これいる？

    // TODO: UseCaseがRxに依存するのはいいのか？？？ -> 厳密にはよくないが外部ライブラリに依存することを許容する
    var subscribableModelList: Observable<[KyotoCityInfo]> { get }
}

protocol KyotoCityInfoUseCaseOutput {
    // TODO: このメソッドはこの実装でいいのか再度確認する
    // func useCaseDidFetchKyotoCityInfo(_ infoList: KyotoCityInfoList)
}

// TODO: これいる？
protocol KyotoCityInfoGatewayProtocol {
    
}

final class KyotoCityInfoUseCase: KyotoCityInfoUseCaseProtocol {
    
    // TODO: InfoTopPageViewModelから移行した処理、あとで整理
    private let rssUrlStr = "https://www.city.kyoto.lg.jp/menu2/rss/rss.xml"
    private let modelListPublishRelay = PublishRelay<[KyotoCityInfo]>()

    // TODO: KyotoCityInfoUseCaseProtocolにこのsubscribeを公開しておくことで良いのか？
    // そうすると、KyotoCityInfoUseCaseOutputはいらなくなりそうな・・・
    var subscribableModelList: Observable<[KyotoCityInfo]> {
        // TODO: mapで必要な処理を行いObservable or Driveを返す
        return modelListPublishRelay.asObservable()
    }
    private var disposeBag = DisposeBag()
    private var modelList: [KyotoCityInfo] = []

    
    // var output: KyotoCityInfoUseCaseOutput!
    // var kyotoCityInfoGateway: KyotoCityInfoGatewayProtocol!
    
    func fetch() {
        // TODO: 京都市のAPI経由でデータを集めてくる
        // TODO: Kyotoというワードがなんども出てきて不要なので変数名などはあとで修正
        // let dummyInfo = [KyotoCityInfo()]
        // self.output.useCaseDidFetchKyotoCityInfo(KyotoCityInfoList(kyotoCityInfoList: dummyInfo))
        
        // TODO: InfoTopPageViewModelから移行した処理、あとで整理
        Alamofire.request(rssUrlStr).responseData { [weak self] (response) in
            guard let self = self else { return }
            
            if let data = response.data {
                let xml = XML.parse(data)

                for element in xml.rss.channel.item {
                    var model = KyotoCityInfo()
                    model.title = element.title.text ?? ""
                    model.publishDate = element.pubDate.text ?? ""
                    model.link = element.link.text ?? ""
                    
                    self.modelList.append(model)
                }
                
                self.modelListPublishRelay.accept(self.modelList)
            }
        }
    }
}

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
import Firebase

protocol KyotoCityInfoUseCaseProtocol: AnyObject {
    // note: UseCaseがRxに依存するのはいいのか? -> 厳密にはよくないが外部ライブラリに依存することを許容する
    var subscribableModelList: Observable<[KyotoCityInfo]> { get }
    var kyotoCityInfoGateway: KyotoCityInfoGateway!{ get }

    func fetch()
}

final class KyotoCityInfoUseCase: KyotoCityInfoUseCaseProtocol {
    
    private let modelListPublishRelay = PublishRelay<[KyotoCityInfo]>()
    // TODO: KyotoCityInfoUseCaseProtocolにこのsubscribeを公開しておくことで良いのか？
    var subscribableModelList: Observable<[KyotoCityInfo]> {
        // TODO: mapで必要な処理を行いObservable or Driveを返す
        return modelListPublishRelay.asObservable()
    }
    var kyotoCityInfoGateway: KyotoCityInfoGateway!

    func fetch() {
        // TODO: Kyotoというワードがなんども出てきて不要なので変数名などはあとで修正
        kyotoCityInfoGateway.fetch {[weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .failure(let error):
                self.modelListPublishRelay.accept([])// TODO: Fix later
            case .success(let data):
                self.modelListPublishRelay.accept(data)
                self.fetchTranslatedTextSync(source: data)
            }
        }
    }
    
    private func fetchTranslatedTextSync(source list: [KyotoCityInfo]) {
        // TODO: 翻訳処理が不要な場合は処理しない判定処理追加
        let semaphore = DispatchSemaphore(value: 0)
        let translatedList = list.map { element -> KyotoCityInfo in
            var newElement = element
            let translator = TranslatorGateway()
            translator.translate(source: element.title, targetLanguage: .en) { (translatedText) in
                newElement.title = translatedText
                semaphore.signal()
            }
            semaphore.wait()// 翻訳処理が完了するまでwait
            return newElement
        }
        // 翻訳が完了したことを通知
        self.modelListPublishRelay.accept(translatedList)
    }

}

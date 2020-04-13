//
//  KyotoCityInfoInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol KyotoCityInfoInteractorProtocol: AnyObject {
    // note: UseCaseがRxに依存するのはいいのか? -> 厳密にはよくないが外部ライブラリに依存することを許容する
    var subscribableModelList: Observable<[KyotoCityInfo]> { get }
    func fetch()
}

final class KyotoCityInfoInteractor: KyotoCityInfoInteractorProtocol {
    
    private let modelListPublishRelay = PublishRelay<[KyotoCityInfo]>()
    // TODO: KyotoCityInfoInteractorProtocolにこのsubscribeを公開しておくことで良いのか？
    var subscribableModelList: Observable<[KyotoCityInfo]> {
        // TODO: mapで必要な処理を行いObservable or Driveを返す
        return modelListPublishRelay.asObservable()
    }

    // TODO: complitionで返すように修正
    func fetch() {
        let kyotoCityInfoGateway = KyotoCityInfoGateway()
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
        // TODO: 同期処理に不具合があるためあとで再実装
        // TODO: 翻訳処理が不要な場合は処理しない判定処理追加
//        let translator = TranslatorInteractor()
//        let translatedList = list.map { element -> KyotoCityInfo in
//            var newElement = element
//            let semaphore = DispatchSemaphore(value: 0)
//            translator.translate(source: element.title, targetLanguage: .en) { (translatedText) in
//                newElement.title = translatedText
//                semaphore.signal()
//            }
//            semaphore.wait()// 翻訳処理が完了するまでwait
//            return newElement
//        }
//        // 翻訳が完了したことを通知
//        self.modelListPublishRelay.accept(translatedList)
    }

}

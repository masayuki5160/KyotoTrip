//
//  InfoInteractor.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

protocol InfoInteractorProtocol: AnyObject {
    func fetch(complition: @escaping (Result<[KyotoCityInfoEntity], Error>) -> Void)
}

final class InfoInteractor: InfoInteractorProtocol {
    
    struct Dependency {
        let kyotoCityInfoGateway: KyotoCityInfoGatewayProtocol
    }
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func fetch(complition: @escaping (Result<[KyotoCityInfoEntity], Error>) -> Void) {
        dependency.kyotoCityInfoGateway.fetch { response in
            switch response {
            case .failure(let error):
                complition(.failure(error))
            case .success(let data):
                complition(.success(data))
            }
        }
    }
    
    private func fetchTranslatedTextSync(source list: [KyotoCityInfoEntity]) {
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

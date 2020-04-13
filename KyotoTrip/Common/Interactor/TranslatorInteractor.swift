//
//  TranslatorGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Firebase

protocol TranslatorInteractorProtocol: AnyObject {
    
}

class TranslatorInteractor: TranslatorInteractorProtocol {
    private let sourceLanguage = TranslateLanguage.ja
    
    init() {
    }
    
    // TODO: 設定ページで翻訳モデルをダウンロードする処理を追加するときに再度実装
    func downloadModel(targetLanguage: TranslateLanguage) {
        // TODO: 翻訳モデルをダウンロードをする
        let targetModel = TranslateRemoteModel.translateRemoteModel(language: targetLanguage)
        let progress = ModelManager.modelManager().download(
            targetModel,
            conditions: ModelDownloadConditions(
                allowsCellularAccess: true,// TODO: falseがいいか？
                allowsBackgroundDownloading: true
            )
        )
        
        NotificationCenter.default.addObserver(
            forName: .firebaseMLModelDownloadDidSucceed,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let strongSelf = self,
                let userInfo = notification.userInfo,
                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue]
                    as? TranslateRemoteModel,
                model == targetModel
                else { return }
            // The model was downloaded and is available on the device
            // TODO: ダウンロードが完了した後の処理
        }

        NotificationCenter.default.addObserver(
            forName: .firebaseMLModelDownloadDidFail,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let strongSelf = self,
                let userInfo = notification.userInfo,
                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue]
                    as? TranslateRemoteModel
                else { return }
            let error = userInfo[ModelDownloadUserInfoKey.error.rawValue]
            // TODO: ダウンロードに失敗した時の処理
        }
    }
    
    // TODO: 翻訳エラーを返すような処理を追加したい
    func translate(source: String, targetLanguage: TranslateLanguage, complition: @escaping (String) -> Void) {
        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        let translator = NaturalLanguage.naturalLanguage().translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: true,// TODO: falseがいいか？
            allowsBackgroundDownloading: true
        )
        
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }

            translator.translate(source) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return }
                
                complition(translatedText)
            }
        }
    }
}

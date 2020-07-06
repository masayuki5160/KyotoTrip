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
        let languageSettingGateway: LanguageSettingGatewayProtocol
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func fetch(complition: @escaping (Result<[KyotoCityInfoEntity], Error>) -> Void) {
        dependency.kyotoCityInfoGateway.fetch { [weak self] response in
            switch response {
            case .failure(let error):
                complition(.failure(error))

            case .success(let data):
                // Apple reviewer says KyotoTrip cannot show information related to covid-19.
                let filterCoronaInfo = data.filter({ $0.title.contains("コロナ") == false })

                self?.dependency.languageSettingGateway.fetch(complition: { response in
                    switch response {
                    case .success(let setting):
                        if setting == .english {
                            self?.fetchTranslatedInfo(source: filterCoronaInfo, complition: { translatedList in
                                complition(.success(translatedList))
                            })
                        } else {
                            complition(.success(filterCoronaInfo))
                        }
                    case .failure(_):
                        complition(.success(filterCoronaInfo))
                    }
                })
            }
        }
    }

    private func fetchTranslatedInfo(source: [KyotoCityInfoEntity], complition: @escaping ([KyotoCityInfoEntity]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "translateInfo", attributes: .concurrent)

        var translatedInfoList: [KyotoCityInfoEntity] = []
        let translator = TranslatorInteractor()
        for entity in source {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                translator.translate(source: entity.title, targetLanguage: .en) { translatedText in
                    var translatedEntity = entity
                    translatedEntity.title = translatedText
                    translatedInfoList.append(translatedEntity)

                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            // Finished translating text
            complition(translatedInfoList)
        }
    }
}

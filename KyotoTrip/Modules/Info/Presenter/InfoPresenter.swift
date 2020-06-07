//
//  InfoPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation

protocol InfoPresenterProtocol: AnyObject {
    func fetch()
    func didSelectRowAt(indexPath: IndexPath)

    var infoDriver: Driver<[InfoCellViewData]> { get }
}

class InfoPresenter: InfoPresenterProtocol {
    struct Dependency {
        let interactor: InfoInteractorProtocol
        let router: InfoRouterProtocol
    }

    var infoDriver: Driver<[InfoCellViewData]>
    private let kyotoCityInfoRelay = BehaviorRelay<[KyotoCityInfoEntity]>(value: [])
    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency

        infoDriver = kyotoCityInfoRelay.asDriver()
            .map({ cityInfo -> [InfoCellViewData] in
                cityInfo.map { cityInfoEntity -> InfoCellViewData in
                    InfoCellViewData(
                        title: cityInfoEntity.title,
                        publishDate: cityInfoEntity.publishDate,
                        link: cityInfoEntity.link
                    )
                }
            }
        )
    }

    func fetch() {
        dependency.interactor.fetch { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(_):
                self.kyotoCityInfoRelay.accept([])

            case .success(let data):
                self.kyotoCityInfoRelay.accept(data)
            }
        }
    }

    func didSelectRowAt(indexPath: IndexPath) {
        let urlString = kyotoCityInfoRelay.value[indexPath.row].link
        dependency.router.presentWebView(url: urlString)
    }
}

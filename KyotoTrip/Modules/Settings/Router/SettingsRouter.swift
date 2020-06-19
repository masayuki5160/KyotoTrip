//
//  SettingsRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/03.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol SettingsRouterProtocol {
    var view: SettingsViewController { get }

    func transitionToLisenceView()
    func transitionToRestaurantsSearchSettingsView(inject interactor: SettingsInteractor)
    func transitionToLanguageSettingsView(inject interactor: SettingsInteractor)
}

struct SettingsRouter: SettingsRouterProtocol {
    var view: SettingsViewController

    func transitionToLisenceView() {
        let targetVC = AppDefaultDependencies().assembleSettingsLisenceModule()
        view.pushViewController(targetVC, animated: true)
    }

    func transitionToRestaurantsSearchSettingsView(inject interactor: SettingsInteractor) {
        let targetVC = AppDefaultDependencies().assembleSettingsRestaurantsSearchModule(inject: interactor)
        view.pushViewController(targetVC, animated: true)
    }

    func transitionToLanguageSettingsView(inject interactor: SettingsInteractor) {
        let targetVC = AppDefaultDependencies().assembleLanguagesSettingsModule(inject: interactor)
        view.pushViewController(targetVC, animated: true)
    }
}

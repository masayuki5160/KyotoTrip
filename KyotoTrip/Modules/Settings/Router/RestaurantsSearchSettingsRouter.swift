//
//  RestaurantsSearchSettingsRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol RestaurantsSearchSettingsRouterProtocol {
    var view: RestaurantsSearchSettingsViewController { get }

    func transitionToRestaurantsSearchRangeSettingView(inject interactor: SettingsInteractor)
}

struct RestaurantsSearchSettingsRouter: RestaurantsSearchSettingsRouterProtocol {
    var view: RestaurantsSearchSettingsViewController

    func transitionToRestaurantsSearchRangeSettingView(inject interactor: SettingsInteractor) {
        let targetVC = AppDefaultDependencies().assembleSettingsRestaurantsSearchRangeModule(inject: interactor)
        view.pushViewController(targetVC, animated: true)
    }
}

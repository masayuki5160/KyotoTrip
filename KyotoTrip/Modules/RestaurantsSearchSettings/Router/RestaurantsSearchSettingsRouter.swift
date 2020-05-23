//
//  RestaurantsSearchSettingsRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol RestaurantsSearchSettingsRouterProtocol {
    var view: SettingsRestaurantsSearchViewController { get }
    func transitionToRestaurantsSearchRangeSettingView()
}

struct RestaurantsSearchSettingsRouter: RestaurantsSearchSettingsRouterProtocol {
    var view: SettingsRestaurantsSearchViewController
    
    func transitionToRestaurantsSearchRangeSettingView() {
        let targetVC = AppDefaultDependencies().assembleSettingsRestaurantsSearchRangeModule()
        view.pushViewController(targetVC, animated: true)
    }
}

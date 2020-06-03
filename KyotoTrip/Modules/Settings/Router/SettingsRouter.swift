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
    func transitionToRestaurantsSearchSettingsView()
}

struct SettingsRouter: SettingsRouterProtocol {
    var view: SettingsViewController
    
    func transitionToLisenceView() {
        let targetVC = AppDefaultDependencies().assembleSettingsLisenceModule()
        view.pushViewController(targetVC, animated: true)
    }
    
    func transitionToRestaurantsSearchSettingsView() {
        let targetVC = AppDefaultDependencies().assembleSettingsRestaurantsSearchModule()
        view.pushViewController(targetVC, animated: true)
    }
}

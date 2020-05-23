//
//  RestaurantsSearchRangeRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol RestaurantsSearchRangeSettingRouterProtocol {
    var view: SettingsRestaurantsSearchRangeViewController { get }
}

struct RestaurantsSearchRangeSettingRouter: RestaurantsSearchRangeSettingRouterProtocol {
    var view: SettingsRestaurantsSearchRangeViewController
}

//
//  RestaurantDetailRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol RestaurantDetailRouterProtocol {
    var view: RestaurantDetailViewController { get }
}

struct RestaurantDetailRouter: RestaurantDetailRouterProtocol {
    var view: RestaurantDetailViewController
}

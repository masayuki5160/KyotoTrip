//
//  MapViewRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/25.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol MapViewRouterProtocol {
    var view: MapViewController { get }
}

struct MapViewRouter: MapViewRouterProtocol {
    var view: MapViewController
}

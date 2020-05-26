//
//  MapViewRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/25.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol MapViewRouterProtocol {
    var view: MapViewController { get }
    func transitionToBusstopDetailViewController(markerEntity: MarkerEntityProtocol)
    func transitionToCulturalPropertyDetailViewController(markerEntity: MarkerEntityProtocol)
    func transitionToRestaurantDetailViewController(markerEntity: MarkerEntityProtocol)
}

struct MapViewRouter: MapViewRouterProtocol {
    var view: MapViewController
    
    func transitionToBusstopDetailViewController(markerEntity: MarkerEntityProtocol) {
        let targetVC = AppDefaultDependencies()
            .assembleBusstopDetailModule() as! BusstopDetailViewController
        targetVC.visibleFeatureEntity = markerEntity
        view.pushViewController(targetVC, animated: true)
    }
    
    func transitionToCulturalPropertyDetailViewController(markerEntity: MarkerEntityProtocol) {
        let targetVC = AppDefaultDependencies()
            .assembleCulturalPropertyDetailModule() as! CulturalPropertyDetailViewController
        targetVC.visibleFeatureEntity = markerEntity
        view.pushViewController(targetVC, animated: true)
    }
    
    func transitionToRestaurantDetailViewController(markerEntity: MarkerEntityProtocol) {
        let targetVC = AppDefaultDependencies()
            .assembleRestaurantDetailModule() as! RestaurantDetailViewController
        targetVC.visibleFeatureEntity = markerEntity
        view.pushViewController(targetVC, animated: true)
    }
}

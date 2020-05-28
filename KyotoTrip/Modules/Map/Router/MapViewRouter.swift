//
//  MapViewRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/25.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol MapViewRouterProtocol {
    var view: MapViewController { get }
    func transitionToBusstopDetailViewController(inject viewData: BusstopDetailViewData)
    func transitionToCulturalPropertyDetailViewController(inject viewData: CulturalPropertyDetailViewData)
    func transitionToRestaurantDetailViewController(markerEntity: MarkerEntityProtocol)
}

struct MapViewRouter: MapViewRouterProtocol {
    var view: MapViewController
    
    func transitionToBusstopDetailViewController(inject viewData: BusstopDetailViewData) {
        let targetVC = AppDefaultDependencies()
            .assembleBusstopDetailModule(inject: viewData) as! BusstopDetailViewController
        view.pushViewController(targetVC, animated: true)
    }
    
    func transitionToCulturalPropertyDetailViewController(inject viewData: CulturalPropertyDetailViewData) {
        let targetVC = AppDefaultDependencies()
            .assembleCulturalPropertyDetailModule(inject: viewData) as! CulturalPropertyDetailViewController
        view.pushViewController(targetVC, animated: true)
    }
    
    func transitionToRestaurantDetailViewController(markerEntity: MarkerEntityProtocol) {
        let targetVC = AppDefaultDependencies()
            .assembleRestaurantDetailModule() as! RestaurantDetailViewController
        targetVC.markerEntity = markerEntity
        view.pushViewController(targetVC, animated: true)
    }
}

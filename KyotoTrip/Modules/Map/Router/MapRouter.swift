//
//  MapViewRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/25.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol MapRouterProtocol {
    var view: MapViewController { get }
    func transitionToBusstopDetailViewController(inject viewData: BusstopDetailViewData)
    func transitionToCulturalPropertyDetailViewController(inject viewData: CulturalPropertyDetailViewData)
    func transitionToRestaurantDetailViewController(inject viewData: RestaurantDetailViewData)
}

struct MapRouter: MapRouterProtocol {
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
    
    func transitionToRestaurantDetailViewController(inject viewData: RestaurantDetailViewData) {
        let targetVC = AppDefaultDependencies()
            .assembleRestaurantDetailModule(inject: viewData) as! RestaurantDetailViewController
        view.pushViewController(targetVC, animated: true)
    }
}

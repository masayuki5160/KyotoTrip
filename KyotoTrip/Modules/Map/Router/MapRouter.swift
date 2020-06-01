//
//  MapViewRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/25.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol MapRouterProtocol {
    var view: MapViewController { get }
    func transitionToDetailViewController(inject viewData: MarkerViewDataProtocol)
}

struct MapRouter: MapRouterProtocol {
    
    var view: MapViewController
    
    func transitionToDetailViewController(inject viewData: MarkerViewDataProtocol) {
        switch viewData.type {
        case .Busstop:
            let busstopDetailViewData = (viewData as! BusstopMarkerViewData).detail
            transitionToBusstopDetailViewController(inject: busstopDetailViewData)
        case .CulturalProperty:
            let culturalPropertyDetailViewData = (viewData as! CulturalPropertyMarkerViewData).detail
            transitionToCulturalPropertyDetailViewController(inject: culturalPropertyDetailViewData)
        case .Restaurant:
            let restaurantDetailViewData = (viewData as! RestaurantMarkerViewData).detail
            transitionToRestaurantDetailViewController(inject: restaurantDetailViewData)
        default:
            break
        }
    }
    
    private func transitionToBusstopDetailViewController(inject viewData: BusstopDetailViewData) {
        let targetVC = AppDefaultDependencies()
            .assembleBusstopDetailModule(inject: viewData) as! BusstopDetailViewController
        view.pushViewController(targetVC, animated: true)
    }
    
    private func transitionToCulturalPropertyDetailViewController(inject viewData: CulturalPropertyDetailViewData) {
        let targetVC = AppDefaultDependencies()
            .assembleCulturalPropertyDetailModule(inject: viewData) as! CulturalPropertyDetailViewController
        view.pushViewController(targetVC, animated: true)
    }
    
    private func transitionToRestaurantDetailViewController(inject viewData: RestaurantDetailViewData) {
        let targetVC = AppDefaultDependencies()
            .assembleRestaurantDetailModule(inject: viewData) as! RestaurantDetailViewController
        view.pushViewController(targetVC, animated: true)
    }
}

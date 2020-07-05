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

    public func transitionToDetailViewController(inject viewData: MarkerViewDataProtocol) {
        switch viewData.type {
        case .busstop:
            // swiftlint:disable force_cast
            let busstopDetailViewData = (viewData as! BusstopMarkerViewData).detail
            transitionToBusstopDetailViewController(inject: busstopDetailViewData)

        case .culturalProperty:
            // swiftlint:disable force_cast
            let culturalPropertyDetailViewData = (viewData as! CulturalPropertyMarkerViewData).detail
            transitionToCulturalPropertyDetailViewController(inject: culturalPropertyDetailViewData)

        case .restaurant:
            // swiftlint:disable force_cast
            let restaurantDetailViewData = (viewData as! RestaurantMarkerViewData).detail
            transitionToRestaurantDetailViewController(inject: restaurantDetailViewData)

        case .famousSites:
            // swiftlint:disable force_cast
            let famousDetailViewData = (viewData as! FamousSitesMarkerViewData).detail
            transitionToFamousDetailViewController(inject: famousDetailViewData)

        default:
            break
        }
    }

    private func transitionToBusstopDetailViewController(inject viewData: BusstopDetailViewData) {
        // swiftlint:disable force_cast
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

    private func transitionToFamousDetailViewController(inject viewData: FamousSitesDetailViewData) {
        let targetVC = AppDefaultDependencies()
            .assembleFamousSitesDetailModule(inject: viewData) as! FamousSitesDetailViewController
        view.pushViewController(targetVC, animated: true)
    }
}

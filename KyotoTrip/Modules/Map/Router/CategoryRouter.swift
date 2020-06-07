//
//  CategoryRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/25.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import UIKit

protocol CategoryRouterProtocol {
    var view: CategoryViewController { get }

    func showNoEntoryAlert()
    func showUnknownErrorAlert()
    func transitionToDetailViewController(inject viewData: MarkerViewDataProtocol)
}

struct CategoryRouter: CategoryRouterProtocol {
    var view: CategoryViewController

    func showNoEntoryAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "飲食店が見つかりませんでした",
            preferredStyle: .alert
        )
        alert.addAction(
            .init(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )

        view.present(alert, animated: true, completion: nil)
    }

    func showUnknownErrorAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "不明なエラーが発生しました",
            preferredStyle: .alert
        )
        alert.addAction(
            .init(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )

        view.present(alert, animated: true, completion: nil)
    }

    func transitionToDetailViewController(inject viewData: MarkerViewDataProtocol) {
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

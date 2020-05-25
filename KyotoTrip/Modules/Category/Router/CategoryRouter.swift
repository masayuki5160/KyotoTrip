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
}

struct CategoryRouter: CategoryRouterProtocol {
    
    var view: CategoryViewController

    func showNoEntoryAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "飲食店が見つかりませんでした",
            preferredStyle: .alert
        )
        alert.addAction(.init(
            title: "キャンセル",
            style: .cancel,
            handler: nil)
        )

        view.present(alert, animated: true, completion: nil)
    }
    
    func showUnknownErrorAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "不明なエラーが発生しました",
            preferredStyle: .alert
        )
        alert.addAction(.init(
            title: "キャンセル",
            style: .cancel,
            handler: nil)
        )

        view.present(alert, animated: true, completion: nil)
    }
}

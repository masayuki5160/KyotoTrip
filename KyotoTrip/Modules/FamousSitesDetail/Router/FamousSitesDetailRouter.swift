//
//  FamousSitesDetailRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/07/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation
import SafariServices

protocol FamousSitesDetailRouterProtocol {
    var view: FamousSitesDetailViewController { get }

    func presentWebsite(url: URL)
    func openPhoneApp(phoneNumber: String)
}

struct FamousSitesDetailRouter: FamousSitesDetailRouterProtocol {
    var view: FamousSitesDetailViewController

    func presentWebsite(url: URL) {
        view.present(SFSafariViewController(url: url), animated: true, completion: nil)
    }

    func openPhoneApp(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

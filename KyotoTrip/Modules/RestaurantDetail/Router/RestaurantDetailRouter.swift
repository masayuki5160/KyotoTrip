//
//  RestaurantDetailRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import SafariServices

protocol RestaurantDetailRouterProtocol {
    var view: RestaurantDetailViewController { get }
    func presentRestaurantWebsite(url: URL)
    func openPhoneApp(phoneNumber: String)
}

struct RestaurantDetailRouter: RestaurantDetailRouterProtocol {
    var view: RestaurantDetailViewController
    
    func presentRestaurantWebsite(url: URL) {
        view.present(SFSafariViewController(url: url), animated: true, completion: nil)
    }
    
    func openPhoneApp(phoneNumber: String) {
        let url = URL(string: "tel://\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

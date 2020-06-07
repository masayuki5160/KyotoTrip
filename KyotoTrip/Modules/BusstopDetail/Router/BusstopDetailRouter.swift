//
//  BusstopDetailRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/27.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import SafariServices

protocol BusstopDetailRouterProtocol {
    var view: BusstopDetailViewController { get }

    func presentHowToUseBusWebsite()
}

struct BusstopDetailRouter: BusstopDetailRouterProtocol {
    var view: BusstopDetailViewController

    func presentHowToUseBusWebsite() {
        if let url = URL(string: "https://www.city.kyoto.lg.jp/kotsu/page/0000191627.html") {
            view.present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
}

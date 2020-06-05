//
//  InfoRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import SafariServices

protocol InfoRouterProtocol {
    var view: InfoViewController { get }
    func presentWebView(url: String)
}

struct InfoRouter: InfoRouterProtocol {
    let view: InfoViewController
    
    func presentWebView(url: String) {
        let url = URL(string: url)
        if let url = url {
            view.present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
}

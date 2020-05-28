//
//  CulturalPropertyDetailRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

protocol CulturalPropertyDetailRouterProtocol {
    var view: CulturalPropertyDetailViewController { get }
}

struct CulturalPropertyDetailRouter: CulturalPropertyDetailRouterProtocol {
    var view: CulturalPropertyDetailViewController
}

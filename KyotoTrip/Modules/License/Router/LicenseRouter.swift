//
//  LicenseRouter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
protocol LicenseRouterProtocol {
    var viewController: SettingsLicenseViewController { get }
}

struct LicenseRouter: LicenseRouterProtocol {
    var viewController: SettingsLicenseViewController
}

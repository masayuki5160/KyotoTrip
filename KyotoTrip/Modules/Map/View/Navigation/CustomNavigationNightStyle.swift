//
//  CustomNavigationNightStyle.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/27.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import MapboxNavigation

class CustomNavigationNightStyle: NightStyle {
    required init() {
        super.init()
        mapStyleURL = MGLStyle.darkStyleURL
    }

    override func apply() {
        super.apply()
    }
}

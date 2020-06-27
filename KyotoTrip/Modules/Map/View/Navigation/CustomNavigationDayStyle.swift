//
//  CustomNavigationDayStyle.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/27.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import MapboxNavigation

class CustomNavigationDayStyle: DayStyle {
    required init() {
        super.init()
        mapStyleURL = MGLStyle.lightStyleURL
    }

    override func apply() {
        super.apply()
    }
}

//
//  RestaurantPointAnnotation.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/11.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Mapbox

class CustomMGLPointAnnotation: MGLPointAnnotation {
    var viewData: MarkerViewDataProtocol?

    override init() {
        super.init()
    }

    init(viewData: MarkerViewDataProtocol) {
        super.init()

        title = viewData.name
        subtitle = viewData.subtitle
        coordinate = viewData.coordinate
        self.viewData = viewData
    }

    required init?(coder: NSCoder) {
        super.init()
    }
}

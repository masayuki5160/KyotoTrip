//
//  RestaurantPointAnnotation.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/11.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Mapbox

class CustomMGLPointAnnotation: MGLPointAnnotation {
    var entity: MarkerEntityProtocol?

    override init() {
        super.init()
    }
    
    init(entity: MarkerEntityProtocol) {
        super.init()

        title = entity.title
        subtitle = entity.subtitle
        coordinate = entity.coordinate
        self.entity = entity
    }
    
    required init?(coder: NSCoder) {
        super.init()
    }
}

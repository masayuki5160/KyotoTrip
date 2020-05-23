//
//  RestaurantPointAnnotation.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/11.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Mapbox

class RestaurantPointAnnotation: MGLPointAnnotation {
    var entity: RestaurantFeatureEntity?
    override init() {
        super.init()
    }
    
    init(entity: RestaurantFeatureEntity) {
        super.init()
        self.entity = entity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

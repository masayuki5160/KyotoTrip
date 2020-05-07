//
//  VisibleLayer.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct VisibleLayerEntity {
    enum Status: Int {
        case hidden = 0
        case visible
    }
    
    var busstop: Status
    var culturalProperty: Status
    var info: Status
    var restaurant: Status
    
    init() {
        busstop = .hidden
        culturalProperty = .hidden
        info = .hidden
        restaurant = .hidden
    }
    
    init(busstop: Status, culturalProperty: Status, info: Status, restaurant: Status) {
        self.busstop = busstop
        self.culturalProperty = culturalProperty
        self.info = info
        self.restaurant = restaurant
    }
    
    mutating func update(layer: VisibleFeatureCategory) -> VisibleLayerEntity {
        switch layer {
        case .Busstop:
            let nextStatusRawValue = self.busstop.rawValue + 1
            self.busstop = VisibleLayerEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        case .CulturalProperty:
            let nextStatusRawValue = self.culturalProperty.rawValue + 1
            self.culturalProperty = VisibleLayerEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        case .Restaurant:
            let nextStatusRawValue = self.restaurant.rawValue + 1
            self.restaurant = VisibleLayerEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        default:
            break
        }
        
        return self
    }
}

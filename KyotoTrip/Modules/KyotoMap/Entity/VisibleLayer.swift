//
//  VisibleLayer.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct VisibleLayer {
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
    
    mutating func update(layer: VisibleFeatureCategory) -> VisibleLayer {
        switch layer {
        case .Busstop:
            let nextStatusRawValue = self.busstop.rawValue + 1
            self.busstop = VisibleLayer.Status(rawValue: nextStatusRawValue) ?? VisibleLayer.Status.hidden
        case .CulturalProperty:
            let nextStatusRawValue = self.culturalProperty.rawValue + 1
            self.culturalProperty = VisibleLayer.Status(rawValue: nextStatusRawValue) ?? VisibleLayer.Status.hidden
        case .Restaurant:
            let nextStatusRawValue = self.restaurant.rawValue + 1
            self.restaurant = VisibleLayer.Status(rawValue: nextStatusRawValue) ?? VisibleLayer.Status.hidden
        default:
            break
        }
        
        return self
    }
}

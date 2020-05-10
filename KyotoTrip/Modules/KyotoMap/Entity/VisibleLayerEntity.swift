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
    
    func update(layer: VisibleFeatureCategory) -> VisibleLayerEntity {
        var nextStatus: VisibleLayerEntity = VisibleLayerEntity()
        switch layer {
        case .Busstop:
            let nextStatusRawValue = self.busstop.rawValue + 1
            nextStatus.busstop = VisibleLayerEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        case .CulturalProperty:
            let nextStatusRawValue = self.culturalProperty.rawValue + 1
            nextStatus.culturalProperty = VisibleLayerEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        case .Restaurant:
            let nextStatusRawValue = self.restaurant.rawValue + 1
            nextStatus.restaurant = VisibleLayerEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        default:
            break
        }

        return nextStatus
    }
    
    func currentVisibleLayer() -> [VisibleFeatureCategory] {
        return findVisibleLayer()
    }
    
    func currentVisibleLayer() -> VisibleFeatureCategory {
        return findVisibleLayer()[0]
    }
    
    private func findVisibleLayer() -> [VisibleFeatureCategory] {
        var res: [VisibleFeatureCategory] = []
        
        // FIXME: 他に良い書き方があれば修正する
        busstop == .visible ? res.append(.Busstop) : ()
        culturalProperty == .visible ? res.append(.CulturalProperty) : ()
        info == .visible ? res.append(.Event) : ()
        restaurant == .visible ? res.append(.Restaurant) : ()
        
        if res.count > 0 {
            return res
        } else {
            res.append(.None)
            return res
        }
    }
}

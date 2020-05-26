//
//  VisibleLayer.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct MarkerCategoryEntity {
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
    
    func update(category: MarkerCategory) -> MarkerCategoryEntity {
        // Initialize status to show only one category markers
        var nextStatus: MarkerCategoryEntity = MarkerCategoryEntity()

        switch category {
        case .Busstop:
            let nextStatusRawValue = self.busstop.rawValue + 1
            nextStatus.busstop = MarkerCategoryEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        case .CulturalProperty:
            let nextStatusRawValue = self.culturalProperty.rawValue + 1
            nextStatus.culturalProperty = MarkerCategoryEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        case .Restaurant:
            let nextStatusRawValue = self.restaurant.rawValue + 1
            nextStatus.restaurant = MarkerCategoryEntity.Status(rawValue: nextStatusRawValue) ?? Status.hidden
        default:
            break
        }

        return nextStatus
    }
    
    func visibleCategories() -> [MarkerCategory] {
        return findVisibleCategories()
    }
    
    func visibleCategory() -> MarkerCategory {
        return findVisibleCategories()[0]
    }
    
    private func findVisibleCategories() -> [MarkerCategory] {
        var res: [MarkerCategory] = []
        
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

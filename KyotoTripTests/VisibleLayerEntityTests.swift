//
//  VisibleLayerEntityTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/05/19.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class VisibleLayerEntityTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCurrentVisibleLayers() {
        let mockVisibleLayers = VisibleLayerEntity(
            busstop: .visible,
            culturalProperty: .hidden,
            info: .hidden,
            restaurant: .visible
        )
        
        let expected: [VisibleFeatureCategory] = [
        .Busstop,
        .Restaurant
        ]
        let actual: [VisibleFeatureCategory] = mockVisibleLayers.currentVisibleLayer()
        
        XCTAssert(actual.contains(expected[0]))
        XCTAssert(actual.contains(expected[1]))
    }
    
    func testGetCurrentVisibleLayer() {
        let mockVisibleLayers = VisibleLayerEntity(
            busstop: .visible,
            culturalProperty: .hidden,
            info: .hidden,
            restaurant: .visible
        )
        
        let expected = VisibleFeatureCategory.Busstop
        let actual: VisibleFeatureCategory = mockVisibleLayers.currentVisibleLayer()
        
        XCTAssertEqual(expected, actual)
    }
}

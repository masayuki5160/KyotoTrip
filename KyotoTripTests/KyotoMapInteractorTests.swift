//
//  KyotoMapInteractorTests.swift
//  KyotoMapInteractorTests
//
//  Created by TANAKA MASAYUKI on 2020/05/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip
import CoreLocation

class KyotoMapInteractorTests: XCTestCase {
    
    let interactor = KyotoMapInteractor()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUpdateUserPosition() {
        let current = UserPosition.currentLocation

        let expected = UserPosition.kyotoCity
        let actual = interactor.updateUserPosition(current)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testCreateVisibleFeatureForBusstop() {
        let mockAttributes = [
            "path": "pathto/Documents/KyotoMapData/busstop/P11-10_26_GML/P11-10_26-jgd-g_BusStop.shp",
            "P11_001": "五条千本",
            "P11_003_1": "京都バス（株）,京都バス（株）",
            "P11_002": "1,1",
            "P11_004_1": "81,83",
            "layer": "P11-10_26-jgd-g_BusStop"
        ]
        let mockCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        let actual = interactor.createVisibleFeature(
            category: .Busstop,
            coordinate: mockCoordinate,
            attributes: mockAttributes
        )
        let expected = BusstopFeatureEntity(
            title: mockAttributes["P11_001"]!,
            subtitle: "",
            coordinate: mockCoordinate,
            type: .Busstop
        )

        XCTAssert(String(describing: type(of: expected)) == String(describing: type(of: actual)))
        XCTAssertEqual(expected.title, actual.title)
        XCTAssertEqual(expected.type, actual.type)
    }
}

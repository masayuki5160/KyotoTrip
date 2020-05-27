//
//  MapInteractorTests.swift
//  MapInteractorTests
//
//  Created by TANAKA MASAYUKI on 2020/05/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip
import CoreLocation

class MapInteractorTests: XCTestCase {
    
    let interactor = MapInteractor()

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
            "P11_003_1": "京都バス（株）,京阪バス（株）",
            "P11_002": "1,1",
            "P11_004_1": "81,83",
            "layer": "P11-10_26-jgd-g_BusStop"
        ]
        let mockCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        let actual = interactor.createMarkerEntity(
            category: .Busstop,
            coordinate: mockCoordinate,
            attributes: mockAttributes
        ) as! BusstopMarkerEntity
        let expected = BusstopMarkerEntity(
            title: mockAttributes["P11_001"]!,
            coordinate: mockCoordinate,
            type: .Busstop,
            routeNameString: mockAttributes["P11_004_1"]!,
            organizationNameString: mockAttributes["P11_003_1"]!
        )

        XCTAssert(String(describing: type(of: expected)) == String(describing: type(of: actual)))
        XCTAssertEqual(expected.title, actual.title)
        XCTAssertEqual(expected.type, actual.type)
        XCTAssertEqual(expected.routeNameString, actual.routeNameString)
        XCTAssertEqual(expected.organizationNameString, actual.organizationNameString)
        XCTAssertEqual(2, actual.routes.count)
        XCTAssertEqual(2, actual.organizations.count)
        XCTAssertEqual("京都バス（株）", actual.routesDictionary["81"])
        XCTAssertEqual("京阪バス（株）", actual.routesDictionary["83"])
    }
    
    func testCreateVisibleFeatureForCulturalProperty() {
        let mockAttributes: [String: Any] = [
            "P32_002": 26,
            "P32_009": 4,
            "P32_005": 21,
            "P32_008": 20110325,
            "P32_007": "京都市下京区",
            "P32_003": 26106,
            "P32_001": 34601,
            "P32_004": 2,
            "P32_006": "鍛金"
        ]
        let mockCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        let actual = interactor.createMarkerEntity(
            category: .CulturalProperty,
            coordinate: mockCoordinate,
            attributes: mockAttributes
        ) as! CulturalPropertyMarkerEntity
        let expected = CulturalPropertyMarkerEntity(
            title: mockAttributes["P32_006"] as! String,
            coordinate: mockCoordinate,
            address: mockAttributes["P32_007"] as! String,
            largeClassificationCode: mockAttributes["P32_004"] as! Int,
            smallClassificationCode: mockAttributes["P32_005"] as! Int,
            registerdDate: mockAttributes["P32_008"] as! Int
        )

        XCTAssert(String(describing: type(of: expected)) == String(describing: type(of: actual)))
        XCTAssertEqual(expected.title, actual.title)
        XCTAssertEqual(expected.address, actual.address)
        XCTAssertEqual(expected.largeClassificationCode, actual.largeClassificationCode)
        XCTAssertEqual(expected.smallClassificationCode, actual.smallClassificationCode)
        XCTAssertEqual(expected.registerdDate, actual.registerdDate)
    }
}

//
//  BusstopMarkerEntityTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
import CoreLocation
@testable import KyotoTrip

class BusstopMarkerEntityTests: XCTestCase {
    
    var busstopA: BusstopMarkerEntity?
    var busstopB: BusstopMarkerEntity?

    override func setUp() {
        busstopA = BusstopMarkerEntity(
            title: "五条千本A",
            coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            type: .Busstop,
            routeNameString: "81,83",
            organizationNameString: "京都バス（株）,京阪バス（株）"
        )
        
        busstopB = BusstopMarkerEntity(
            title: "五条千本B",
            coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            type: .Busstop,
            routeNameString: "81",
            organizationNameString: "京都バス（株）"
        )
    }
    
    func test_check_subtitleFormat_whenRouteStringHaveTwoRoutes() {
        let actual = busstopA!.subtitle
        let expected = "[路線] 81 他"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_check_subtitleFormat_whenRouteStringHaveOneRoute() {
        let actual = busstopB!.subtitle
        let expected = "[路線] 81"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_check_routesArray_whenRouteStringHaveTwoRoutes() {
        let actual = busstopA!.routes
        let expected = ["81","83"]
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_check_routesArray_whenRouteStringHaveOneRoute() {
        let actual = busstopB!.routes
        let expected = ["81"]
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_check_organizationsArray_whenRouteStringHaveTwoRoutes() {
        let actual = busstopA!.organizations
        let expected = ["京都バス（株）","京阪バス（株）"]
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_check_organizationsArray_whenRouteStringHaveOneRoute() {
        let actual = busstopB!.organizations
        let expected = ["京都バス（株）"]
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

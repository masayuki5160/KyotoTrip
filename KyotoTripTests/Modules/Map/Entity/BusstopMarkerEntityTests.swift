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
    
    var mock01Entity: BusstopMarkerEntity?
    var mock02Entity: BusstopMarkerEntity?

    override func setUp() {
        mock01Entity = BusstopMarkerEntity(
            title: "五条千本MockData",
            coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            type: .Busstop,
            routeNameString: "81,83",
            organizationNameString: "京都バス（株）,京阪バス（株）"
        )
        
        mock02Entity = BusstopMarkerEntity(
            title: "五条千本MockData",
            coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            type: .Busstop,
            routeNameString: "81",
            organizationNameString: "京都バス（株）"
        )
    }
    
    func testSubtitleFormat1() {
        let actual = mock01Entity!.subtitle
        let expected = "[路線] 81 他"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSubtitleFormat2() {
        let actual = mock02Entity!.subtitle
        let expected = "[路線] 81"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testRoutesArray1() {
        let actual = mock01Entity!.routes
        let expected = ["81","83"]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testRoutesArray2() {
        let actual = mock02Entity!.routes
        let expected = ["81"]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testOrganizationsArray1() {
        let actual = mock01Entity!.organizations
        let expected = ["京都バス（株）","京阪バス（株）"]
        
        XCTAssertEqual(expected, actual)
    }
    
    func testOrganizationsArray2() {
        let actual = mock02Entity!.organizations
        let expected = ["京都バス（株）"]
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

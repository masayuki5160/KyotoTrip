//
//  CulturalPropertyMarkerEntityTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
import CoreLocation
@testable import KyotoTrip

class CulturalPropertyMarkerEntityTests: XCTestCase {
    
    var mockEntity: CulturalPropertyMarkerEntity?

    override func setUp() {
        mockEntity = CulturalPropertyMarkerEntity(
            title: "鍛金",
            coordinate: CLLocationCoordinate2D(latitude: 34.987552236426936, longitude: 135.75546026229858),
            address: "京都市下京区",
            largeClassificationCode: 2,
            smallClassificationCode: 21,
            registerdDate: 20110325
        )
    }
    
    func testFormatRegisterDate() {
        let actual = mockEntity!.registerDateString
        let expected = "2011/03/25"
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

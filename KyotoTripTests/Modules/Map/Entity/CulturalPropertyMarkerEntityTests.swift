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
    
    var markerEntity: CulturalPropertyMarkerEntity?

    override func setUp() {
        markerEntity = CulturalPropertyMarkerEntity(
            title: "鍛金",
            coordinate: CLLocationCoordinate2D(latitude: 34.987552236426936, longitude: 135.75546026229858),
            address: "京都市下京区",
            largeClassificationCode: 2,
            smallClassificationCode: 21,
            registerdDate: 20110325
        )
    }
    
    func test_check_FormatRegisterDate() {
        let actual = markerEntity!.registerDateString
        let expected = "2011/03/25"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctLargeClassificationName() {
        let actual = markerEntity!.largeClassification
        let expected = "無形文化財"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctSmallClassificationName() {
        let actual = markerEntity!.smallClassification
        let expected = "無形文化財"
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

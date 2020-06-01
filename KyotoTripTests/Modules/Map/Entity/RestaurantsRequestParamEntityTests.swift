//
//  RestaurantsRequestParamEntityTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class RestaurantsRequestParamEntityTests: XCTestCase {

    override func setUp() {
    }
    
    func testSearchRange300ToString() {
        let range: RestaurantsRequestParamEntity.SearchRange = .range300
        let actual = range.toString()
        let expected = "300m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSearchRange500ToString() {
        let range: RestaurantsRequestParamEntity.SearchRange = .range500
        let actual = range.toString()
        let expected = "500m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSearchRange1000ToString() {
        let range: RestaurantsRequestParamEntity.SearchRange = .range1000
        let actual = range.toString()
        let expected = "1000m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSearchRange2000ToString() {
        let range: RestaurantsRequestParamEntity.SearchRange = .range2000
        let actual = range.toString()
        let expected = "2000m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSearchRange3000ToString() {
        let range: RestaurantsRequestParamEntity.SearchRange = .range3000
        let actual = range.toString()
        let expected = "3000m"
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

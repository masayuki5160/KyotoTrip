//
//  RestaurantsRequestParamEntityTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class RestaurantsRequestSearchRangeTests: XCTestCase {

    override func setUp() {
    }
    
    func test_is_correctSearchRange300String() {
        let range: RestaurantsRequestSearchRange = .range300
        let actual = range.toString()
        let expected = "300m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctSearchRange500String() {
        let range: RestaurantsRequestSearchRange = .range500
        let actual = range.toString()
        let expected = "500m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctSearchRange1000String() {
        let range: RestaurantsRequestSearchRange = .range1000
        let actual = range.toString()
        let expected = "1000m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctSearchRange2000String() {
        let range: RestaurantsRequestSearchRange = .range2000
        let actual = range.toString()
        let expected = "2000m"
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctSearchRange3000String() {
        let range: RestaurantsRequestSearchRange = .range3000
        let actual = range.toString()
        let expected = "3000m"
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

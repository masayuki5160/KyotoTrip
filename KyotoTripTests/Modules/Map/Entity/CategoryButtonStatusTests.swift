//
//  CategoryButtonStatusTest.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/01.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class CategoryButtonStatusTests: XCTestCase {

    override func setUp() {
    }
    
    func testChangeStatusToVisible() {
        let status: CategoryButtonStatus = .hidden
        let actual = status.next()
        let expected: CategoryButtonStatus = .visible
        
        XCTAssertEqual(expected, actual)
    }
    
    func testChangeStatusToHidden() {
        let status: CategoryButtonStatus = .visible
        let actual = status.next()
        let expected: CategoryButtonStatus = .hidden
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

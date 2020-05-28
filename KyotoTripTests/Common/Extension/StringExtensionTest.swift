//
//  StringExtensionTest.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class StringExtensionTest: XCTestCase {

    override func setUp() {
    }

    func testReplaceExtension() {
        let actual = "050-3477-8987".replace(from: "-", to: "")
        let expected = "05034778987"
        
        XCTAssertEqual(expected, actual)
    }

    override func tearDown() {
    }
}

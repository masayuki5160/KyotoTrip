//
//  KyotoMapInteractorTests.swift
//  KyotoMapInteractorTests
//
//  Created by TANAKA MASAYUKI on 2020/05/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

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
}

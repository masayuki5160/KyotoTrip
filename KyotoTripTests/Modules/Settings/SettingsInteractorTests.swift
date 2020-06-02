//
//  SettingsInteractorTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/02.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class SettingsInteractorTests: XCTestCase {
    override func setUp() {
    }
    
    func testShouldFetchSavedParam() {
        /// Build SettingsInteractor() for test
        var settings = RestaurantsRequestParamEntity()
        settings.englishSpeakingStaff = .on
        settings.range = .range1000
        let gatewayStub = RestaurantsRequestParamGatewayStub(result: .success(settings))
        let settingsInteractor = SettingsInteractor(dependency: .init(restaurantsRequestParamGateway: gatewayStub))
        
        let functionAnswered = expectation(description: "asynchronous function")
        settingsInteractor.fetchRestaurantsRequestParam { requestEntity in
            let actualEnglishSpeakingStaff = requestEntity.englishSpeakingStaff
            let expectedEnglishSpeakingStaff: RestaurantsRequestParamEntity.RequestFilterFlg = .on
            XCTAssertEqual(expectedEnglishSpeakingStaff, actualEnglishSpeakingStaff)
            
            let actualRange = requestEntity.range
            let expectedRange: RestaurantsRequestSearchRange = .range1000
            XCTAssertEqual(expectedRange, actualRange)
            
            functionAnswered.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    override func tearDown() {
    }
}

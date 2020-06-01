//
//  MapInteractorTests.swift
//  MapInteractorTests
//
//  Created by TANAKA MASAYUKI on 2020/05/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip
import CoreLocation

class MapInteractorTests: XCTestCase {
    
    var interactor: MapInteractor?

    override func setUp() {
        interactor = MapInteractor(dependency: .init(
            searchGateway: RestaurantsSearchGatewayStub(),
            requestParamGateway: RestaurantsRequestParamGatewayStub()
            )
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

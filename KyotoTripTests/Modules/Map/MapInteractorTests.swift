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
        
    }
    
    private func createRestaurantSearchResult() -> RestaurantsSearchResultEntity {
        /// Set dummy data with json file
        let path = Bundle.main.path(forResource: "gnaviAPIDummyResponse", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)

        /// decode dummy json file
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let resultEntity = try! decoder.decode(RestaurantsSearchResultEntity.self, from: data)
        
        return resultEntity
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

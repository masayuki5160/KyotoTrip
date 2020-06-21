//
//  MapInteractorTests.swift
//  MapInteractorTests
//
//  Created by TANAKA MASAYUKI on 2020/05/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip
import RxSwift
import RxCocoa
import CoreLocation

class MapInteractorTests: XCTestCase {
    
    var interactor: MapInteractor?
    var searchResults: RestaurantsSearchResultEntity?

    override func setUp() {
        let settings = RestaurantsRequestParamEntity()
        searchResults = createRestaurantSearchResult()
        let restaurantsSearchGatewayStub = RestaurantsSearchGatewayStub(result: .success(searchResults!))
        let restaurantsRequestParamGateway = RestaurantsRequestParamGatewayStub(result: .success(settings))

        interactor = MapInteractor(dependency: .init(
            searchGateway: restaurantsSearchGatewayStub,
            requestParamGateway: restaurantsRequestParamGateway,
            languageSettingGateway: LanguageSettingGatewayStub(result: .success(.japanese)),
            userInfoGateway: UserInfoGatewayStub(result: .success(true)))
        )
    }
    
    func test_check_isEmptyRestaurantMarker_whenRestaurantsButtonStatusIsHidden() {
        interactor?.didSelectRestaurantButton(nextStatus: .hidden)
        let disposeBag = DisposeBag()

        let functionAnswered = expectation(description: "asynchronous function")
        interactor?.restaurantMarkersDriver.drive(onNext: { markers in
            XCTAssertEqual(0, markers.count)
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_check_isNotEmptyRestaurantMarker_whenRestaurantsButtonStatusIsVisible() {
        interactor?.didSelectRestaurantButton(nextStatus: .visible)
        let disposeBag = DisposeBag()

        let functionAnswered = expectation(description: "asynchronous function")
        interactor?.restaurantMarkersDriver.drive(onNext: { [weak self] markers in
            let expectedCount = self?.searchResults?.rest.count
            
            XCTAssertEqual(expectedCount, markers.count)
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)

        waitForExpectations(timeout: 1, handler: nil)
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

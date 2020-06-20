//
//  MapPresenterTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip
import RxSwift
import RxCocoa
import CoreLocation

class MapPresenterTests: XCTestCase {
    
    var interactor: MapInteractorStub!
    var presenter: MapPresenter!
    var view: MapViewController!

    override func setUp() {
        let settings = RestaurantsRequestParamEntity()
        let searchResults = createRestaurantSearchResult()
        interactor = MapInteractorStub(dependency: .init(
            searchGateway: RestaurantsSearchGatewayStub(
                result: .success(searchResults)),
            requestParamGateway: RestaurantsRequestParamGatewayStub(
                result: .success(settings))
            )
        )
        
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        view = naviViewController.viewControllers[0] as? MapViewController
        let router = MapRouter(view: view)
        presenter = MapPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )
        
        //view.loadViewIfNeeded()
    }
    
    func test_check_categoryButtonStatus_whenRestaurantsIsVisible() {
        /// Input to Interactor
        interactor.didSelectBusstopButton(nextStatus: .visible)
        interactor.didSelectRestaurantButton(nextStatus: .visible)
        interactor.didSelectCulturalPropertyButton(nextStatus: .hidden)
        
        let disposeBag = DisposeBag()
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.categoryButtonsStatusDriver.drive(onNext: { viewData in
            XCTAssertEqual(CategoryButtonStatus.visible, viewData.busstop)
            XCTAssertEqual(CategoryButtonStatus.visible, viewData.restaurant)
            XCTAssertEqual(CategoryButtonStatus.hidden, viewData.culturalProperty)

            functionAnswered.fulfill()
        }).disposed(by: disposeBag)

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_check_categoryButtonStatus_whenRestaurantsIsHidden() {
        /// Input to Interactor
        interactor.didSelectBusstopButton(nextStatus: .visible)
        interactor.didSelectRestaurantButton(nextStatus: .hidden)
        interactor.didSelectCulturalPropertyButton(nextStatus: .hidden)
        
        let disposeBag = DisposeBag()
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.categoryButtonsStatusDriver.drive(onNext: { viewData in
            XCTAssertEqual(CategoryButtonStatus.visible, viewData.busstop)
            XCTAssertEqual(CategoryButtonStatus.hidden, viewData.restaurant)
            XCTAssertEqual(CategoryButtonStatus.hidden, viewData.culturalProperty)

            functionAnswered.fulfill()
        }).disposed(by: disposeBag)

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_check_mapCenterPositionIsUserPosition_whenTapOneth() {
        let tapEvent = PublishRelay<()>()
        presenter.bindMapView(input: .init(compassButtonTapEvent: tapEvent.asDriver(onErrorJustReturn: ())))
        
        let disposeBag = DisposeBag()

        let functionAnswered = expectation(description: "asynchronous function")
        presenter.mapCenterPositionDriver.drive(onNext: { actualPosition in
            XCTAssertEqual(MapCenterPosition.userLocation, actualPosition)
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        tapEvent.accept(())

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_check_mapCenterPositionIsKyotoCity_whenTapTwise() {
        let tapEvent = PublishRelay<()>()
        presenter.bindMapView(input: .init(compassButtonTapEvent: tapEvent.asDriver(onErrorJustReturn: ())))

        let disposeBag = DisposeBag()

        let functionAnswered = expectation(description: "asynchronous function")
        var tapCounter = 0
        presenter.mapCenterPositionDriver.drive(onNext: { actualPosition in
            if tapCounter > 0 {
                XCTAssertEqual(MapCenterPosition.kyotoCity, actualPosition)
                functionAnswered.fulfill()
            }
            
            tapCounter += 1
        }).disposed(by: disposeBag)
        
        // Tap twice
        tapEvent.accept(())
        tapEvent.accept(())

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
    }
}

private extension MapPresenterTests {
    private func createRestaurantSearchResult() -> RestaurantsSearchResultEntity {
        /// Set dummy data with json file
        let path = Bundle.main.path(forResource: "gnaviAPIDummyResponse", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)

        /// decode dummy json file
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let resultEntity = try decoder.decode(RestaurantsSearchResultEntity.self, from: data)
            return resultEntity
        } catch let error {
            print("error=>\(error)")
            return RestaurantsSearchResultEntity()
        }
    }
}

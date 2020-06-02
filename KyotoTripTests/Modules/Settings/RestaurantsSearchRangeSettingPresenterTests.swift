//
//  RestaurantsSearchRangeSettingPresenterTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/02.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import KyotoTrip

class RestaurantsSearchRangeSettingPresenterTests: XCTestCase {
    
    var view: RestaurantsSearchRangeSettingsViewController!
    var gateway: RestaurantsRequestParamGatewayStub!
    var interactor: SettingsInteractor!
    var router: RestaurantsSearchRangeSettingRouter!
    var presenter: RestaurantsSearchRangeSettingPresenter!
    
    override func setUp() {
        view = { () -> RestaurantsSearchRangeSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearchRange", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchRangeSettingsViewController
        }()
        gateway = { () -> RestaurantsRequestParamGatewayStub in
            let settings = RestaurantsRequestParamEntity()
            return RestaurantsRequestParamGatewayStub(result: .success(settings))
        }()
        interactor = SettingsInteractor(dependency: .init(restaurantsRequestParamGateway: gateway))
        router = RestaurantsSearchRangeSettingRouter(view: view)
        presenter = RestaurantsSearchRangeSettingPresenter(dependency: .init(
            interactor: interactor,
            router: router
            )
        )
        view.inject(.init(presenter: presenter))
    }
    
    func test_is_selectedCorrectSearchRange_whenDefault() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.searchRangeRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[0].isSelected)
            XCTAssertTrue(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)

            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
    }
}

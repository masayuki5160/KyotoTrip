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
    var presenter: RestaurantsSearchRangeSettingPresenter!
    
    override func setUp() {
        view = { () -> RestaurantsSearchRangeSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearchRange", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchRangeSettingsViewController
        }()
        let gateway = { () -> RestaurantsRequestParamGatewayStub in
            let settings = RestaurantsRequestParamEntity()
            return RestaurantsRequestParamGatewayStub(result: .success(settings))
        }()
        let languageSettingGateway = LanguageSettingGatewayStub(result: .success(.japanese))
        let interactor = SettingsInteractor(dependency: .init(
            restaurantsRequestParamGateway: gateway,
            languageSettingGateway: languageSettingGateway
            )
        )
        let router = RestaurantsSearchRangeSettingRouter(view: view)
        presenter = RestaurantsSearchRangeSettingPresenter(dependency: .init(
            interactor: interactor,
            router: router
            )
        )
        view.inject(.init(presenter: presenter))
    }
    
    func test_is_selectedCorrectSearchRange_whenLaunchedApp() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.searchRangeRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[0].isSelected)
            XCTAssertTrue(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)

            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctCellsViewDatas_whenCellIsSelected() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultcell = RestaurantsSearchRangeCellViewData(
            range: .range500,
            isSelected: true
        )
        let relay = BehaviorRelay<RestaurantsSearchRangeCellViewData>(value: defaultcell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        let selectedCell = RestaurantsSearchRangeCellViewData(
            range: .range2000,
            isSelected: true
        )
        /// Send selected cell to Presenter
        relay.accept(selectedCell)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.searchRangeRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[0].isSelected)
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertTrue(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)

            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
    }
}

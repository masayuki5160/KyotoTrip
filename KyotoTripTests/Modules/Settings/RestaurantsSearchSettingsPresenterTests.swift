//
//  RestaurantsSearchSettingsPresenterTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/03.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import KyotoTrip

class RestaurantsSearchSettingsPresenterTests: XCTestCase {
    
    var view: RestaurantsSearchSettingsViewController!
    var gateway: RestaurantsRequestParamGatewayStub!
    var interactor: SettingsInteractor!
    var router: RestaurantsSearchSettingsRouter!
    var presenter: RestaurantsSearchSettingsPresenter!
    
    override func setUp() {
        view = { () -> RestaurantsSearchSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearch", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchSettingsViewController
        }()

        gateway = { () -> RestaurantsRequestParamGatewayStub in
            let settings = RestaurantsRequestParamEntity()
            return RestaurantsRequestParamGatewayStub(result: .success(settings))
        }()
        interactor = SettingsInteractor(dependency: .init(restaurantsRequestParamGateway: gateway))
        router = RestaurantsSearchSettingsRouter(view: view)
        presenter = RestaurantsSearchSettingsPresenter(dependency: .init(
            interactor: interactor,
            router: router
            )
        )
        view.inject(.init(presenter: presenter))
    }
    
    func test_is_correctDefaultSettingsRows_whenLaunchedApp() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)

            XCTAssertEqual("検索範囲", cells[0].title)
            XCTAssertEqual("500m", cells[0].detail)
            XCTAssertEqual("英語スタッフ", cells[1].title)
            XCTAssertEqual("韓国語スタッフ", cells[2].title)
            XCTAssertEqual("中国語スタッフ", cells[3].title)
            XCTAssertEqual("ベジタリアンメニュー", cells[4].title)
            XCTAssertEqual("クレジットカード", cells[5].title)
            XCTAssertEqual("個室", cells[6].title)
            XCTAssertEqual("Wifi", cells[7].title)
            XCTAssertEqual("禁煙", cells[8].title)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateEnglishSpeakerSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "英語スタッフ",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertTrue(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateKoreanSpeakerSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "韓国語スタッフ",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertTrue(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateChainesSpeakerSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "中国語スタッフ",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertTrue(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateVesitalianSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "ベジタリアンメニュー",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertTrue(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateCreditCardSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "クレジットカード",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertTrue(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateNoSmokingSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "禁煙",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertTrue(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdatePrivateRoomSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "個室",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertTrue(cells[6].isSelected)
            XCTAssertFalse(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateWifiSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData()
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "Wifi",
            detail: "",
            isSelected: false
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertFalse(cells[3].isSelected)
            XCTAssertFalse(cells[4].isSelected)
            XCTAssertFalse(cells[5].isSelected)
            XCTAssertFalse(cells[6].isSelected)
            XCTAssertTrue(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
    }
}

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
    var presenter: RestaurantsSearchSettingsPresenter!
    
    override func setUp() {
        view = { () -> RestaurantsSearchSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearch", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchSettingsViewController
        }()

        let restaurantsRequestParamGateway = { () -> RestaurantsRequestParamGatewayStub in
            let settings = RestaurantsRequestParamEntity()
            return RestaurantsRequestParamGatewayStub(result: .success(settings))
        }()
        let languageSettingGateway = LanguageSettingGatewayStub(result: .success(.japanese))
        let interactor = SettingsInteractor(dependency: .init(
            restaurantsRequestParamGateway: restaurantsRequestParamGateway,
            languageSettingGateway: languageSettingGateway
            )
        )
        let router = RestaurantsSearchSettingsRouter(view: view)
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

            XCTAssertEqual("RestaurantSearchSettingsPageSearchRange".localized, cells[0].title)
            XCTAssertEqual("500m", cells[0].detail)
            XCTAssertEqual("RestaurantSearchSettingsPageEnglishSpeaker".localized, cells[1].title)
            XCTAssertEqual("RestaurantSearchSettingsPageKoreanSpeaker".localized, cells[2].title)
            XCTAssertEqual("RestaurantSearchSettingsPageChineseSpeaker".localized, cells[3].title)
            XCTAssertEqual("RestaurantSearchSettingsPageVegetarian".localized, cells[4].title)
            XCTAssertEqual("RestaurantSearchSettingsPageCreditCard".localized, cells[5].title)
            XCTAssertEqual("RestaurantSearchSettingsPagePrivateRoom".localized, cells[6].title)
            XCTAssertEqual("RestaurantSearchSettingsPageWifi".localized, cells[7].title)
            XCTAssertEqual("RestaurantSearchSettingsPageNoSmoking".localized, cells[8].title)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdateEnglishSpeakerSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .chaineseSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "英語スタッフ",
            detail: "",
            isSelected: false,
            category: .englishSpeaker
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertTrue(cells[1].isSelected)
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
    
    func test_is_correctDefaultSettingsRows_whenUpdateKoreanSpeakerSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .chaineseSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "韓国語スタッフ",
            detail: "",
            isSelected: false,
            category: .koreanSpeaker
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertTrue(cells[2].isSelected)
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
    
    func test_is_correctDefaultSettingsRows_whenUpdateChainesSpeakerSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .koreanSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "中国語スタッフ",
            detail: "",
            isSelected: false,
            category: .chaineseSpeaker
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertTrue(cells[2].isSelected)
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
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .chaineseSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "ベジタリアンメニュー",
            detail: "",
            isSelected: false,
            category: .vegetarian
        )
        let relay = BehaviorRelay<RestaurantsSearchSettingsCellViewData>(value: defaultCell)
        presenter.bindView(input: .init(selectedCell: relay.asDriver()))
        relay.accept(selectedCellViewData)
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.settingsRowsDriver.drive(onNext: { cells in
            XCTAssertFalse(cells[1].isSelected)
            XCTAssertFalse(cells[2].isSelected)
            XCTAssertTrue(cells[3].isSelected)
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
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .chaineseSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "クレジットカード",
            detail: "",
            isSelected: false,
            category: .creditCard
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
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .chaineseSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "禁煙",
            detail: "",
            isSelected: false,
            category: .noSmoking
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
            XCTAssertTrue(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_is_correctDefaultSettingsRows_whenUpdatePrivateRoomSeachSetting() {
        view.loadViewIfNeeded()
        let disposeBag = DisposeBag()
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .chaineseSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "個室",
            detail: "",
            isSelected: false,
            category: .privateRoom
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
        
        let defaultCell = RestaurantsSearchSettingsCellViewData(category: .chaineseSpeaker)
        let selectedCellViewData = RestaurantsSearchSettingsCellViewData(
            title: "Wifi",
            detail: "",
            isSelected: false,
            category: .wifi
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
            XCTAssertTrue(cells[7].isSelected)
            XCTAssertFalse(cells[8].isSelected)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
    }
}

//
//  SettingsPresenterTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/02.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class SettingsPresenterTests: XCTestCase {
    
    var presenter: SettingsPresenter!
    
    override func setUp() {
        let view = { () -> SettingsViewController in
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let naviViewController = storyboard.instantiateInitialViewController() as! UINavigationController
            return naviViewController.viewControllers[0] as! SettingsViewController
        }()
        let restaurantRequestParamGateway = { () -> RestaurantsRequestParamGatewayStub in
            let settings = RestaurantsRequestParamEntity()
            return RestaurantsRequestParamGatewayStub(result: .success(settings))
        }()
        let languageGateway = LanguageSettingGatewayStub(result: .success(.japanese))
        let interactor = SettingsInteractor(dependency: .init(
            restaurantsRequestParamGateway: restaurantRequestParamGateway,
            languageSettingGateway: languageGateway
            )
        )
        let router = SettingsRouter(view: view)
        presenter = SettingsPresenter(dependency: .init(
            interactor: interactor,
            router: router
            )
        )
        view.inject(.init(presenter: presenter))
    }
    
    func test_is_correctAppVersionRowProperty_atInfoSection() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = presenter.cellForSettings(indexPath: indexPath)
        
        XCTAssertEqual(UITableViewCell.AccessoryType.none, cell.accessoryType)
        XCTAssertEqual(UITableViewCell.SelectionStyle.none, cell.selectionStyle)
    }
    
    func test_is_correctLisenceRowProperty_atInfoSection() {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = presenter.cellForSettings(indexPath: indexPath)
        
        XCTAssertEqual(UITableViewCell.AccessoryType.disclosureIndicator, cell.accessoryType)
    }
    
    func test_is_correctLanguageSettingRowProperty_atApplicationSection() {
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = presenter.cellForSettings(indexPath: indexPath)
        
        XCTAssertEqual(UITableViewCell.AccessoryType.disclosureIndicator, cell.accessoryType)
    }

    func test_is_correctRestaurantsSettingRowProperty_atApplicationSection() {
        let indexPath = IndexPath(row: 1, section: 1)
        let cell = presenter.cellForSettings(indexPath: indexPath)
        
        XCTAssertEqual(UITableViewCell.AccessoryType.disclosureIndicator, cell.accessoryType)
    }
    
    override func tearDown() {
    }
}

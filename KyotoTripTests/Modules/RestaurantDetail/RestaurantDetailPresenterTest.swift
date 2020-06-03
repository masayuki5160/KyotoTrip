//
//  RestaurantDetailPresenterTest.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class RestaurantDetailPresenterTest: XCTestCase {
    
    var presenter: RestaurantDetailPresenter!
    let viewData = RestaurantDetailViewData(
        name: "鶏料理専門 京都駅本店",
        nameKana: "トリリョウリセンモン キョウトエキホンテン",
        address: "〒601-1111 京都府京都市南区",
        access: "ＪＲ京都駅八条口",
        tel: "050-1111-2222",
        businessHour: " ランチ：11:30～14:00(L.O.13:30)",
        holiday: "毎週水曜日",
        salesPoint: "キャッシュレスで5％還元中！",
        url: "https://r.gnavi.co.jp/",
        imageUrl: "https://rimage.gnst.jp/"
    )

    override func setUp() {
        let view = { () -> RestaurantDetailViewController in
            let storyboard = UIStoryboard(name: "RestaurantDetail", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantDetailViewController
        }()
        let router = RestaurantDetailRouter(view: view)
        presenter = RestaurantDetailPresenter(
            dependency: .init(
                router: router,
                viewData: viewData
            )
        )
    }
    
    func test_is_correctNameSction_atCreatedCell() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actualName = cell.textLabel?.text
        let expectedName = viewData.name
        let actualKanaName = cell.detailTextLabel?.text
        let expectedKanaName = viewData.nameKana
        
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedKanaName, actualKanaName)
    }
    
    func test_is_correctAddressSection_atCreatedCell() {
        let indexPath = IndexPath(item: 0, section: 1)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actualAddress = cell.textLabel?.text
        let expectedAddress = viewData.address
        let actualAccess = cell.detailTextLabel?.text
        let expectedAccess = viewData.access
        
        
        XCTAssertEqual(expectedAddress, actualAddress)
        XCTAssertEqual(expectedAccess, actualAccess)
    }
    
    func test_is_correctBusinessHourSection_atCreatedCell() {
        let indexPath = IndexPath(item: 0, section: 2)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.businessHour
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctHolidaySection_atCreatedCell() {
        let indexPath = IndexPath(item: 0, section: 3)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.holiday
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctTelSection_atCreatedCell() {
        let indexPath = IndexPath(item: 0, section: 4)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.tel
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctWebpageSection_atCreatedCell() {
        let indexPath = IndexPath(item: 0, section: 5)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.url
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_is_correctOtherSection_atCreatedCell() {
        let indexPath = IndexPath(item: 0, section: 6)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.salesPoint
        
        XCTAssertEqual(expected, actual)
    }
    
    override func tearDown() {
    }
}

//
//  CulturalPropertyDetailPresenterTest.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class CulturalPropertyDetailPresenterTest: XCTestCase {
    
    var presenter: CulturalPropertyDetailPresenter!
    let viewData = CulturalPropertyDetailViewData(
        name: "東福寺9棟1基",
        address: "京都市東山区本町15",
        largeClassification: "有形文化財",
        smallClassification: "有形文化財",
        registerdDate: "1993/04/09"
    )

    override func setUp() {
        let view = { () -> CulturalPropertyDetailViewController in
            let storyboard = UIStoryboard(name: "CulturalPropertyDetail", bundle: nil)
            return storyboard.instantiateInitialViewController() as! CulturalPropertyDetailViewController
        }()
        let router = CulturalPropertyDetailRouter(view: view)
        
        presenter = CulturalPropertyDetailPresenter(
            dependency: .init(
                router: router,
                viewData: viewData
            )
        )
    }
    
    func testCreateCellForNameSection() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.name
        
        XCTAssertEqual(expected, actual)
    }
    
    func testCreateCellForAddressSection() {
        let indexPath = IndexPath(item: 0, section: 1)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.address
        
        XCTAssertEqual(expected, actual)

    }
    
    func testCreateCellForLargeClassificationSection() {
        let indexPath = IndexPath(item: 0, section: 2)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.largeClassification
        
        XCTAssertEqual(expected, actual)

    }

    func testCreateCellForSmallClassificationSection() {
        let indexPath = IndexPath(item: 0, section: 3)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.smallClassification
        
        XCTAssertEqual(expected, actual)

    }

    func testCreateCellForRegisterDateSection() {
        let indexPath = IndexPath(item: 0, section: 4)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.registerdDate
        
        XCTAssertEqual(expected, actual)

    }
    
    override func tearDown() {
    }
}

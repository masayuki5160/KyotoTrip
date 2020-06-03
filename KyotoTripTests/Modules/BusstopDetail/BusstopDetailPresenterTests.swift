//
//  BusstopDetailPresenterTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/03.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
@testable import KyotoTrip

class BusstopDetailPresenterTests: XCTestCase {
    
    var view: BusstopDetailViewController!
    var router: BusstopDetailRouter!
    var presenter: BusstopDetailPresenter!
    let viewData = BusstopDetailViewData(
        name: "五条千本",
        routes: ["81", "83"],
        organizations: ["京都バス（株）", "京阪バス（株）"]
    )

    override func setUp() {
        view = { () -> BusstopDetailViewController in
            let storyboard = UIStoryboard(name: "BusstopDetail", bundle: nil)
            return storyboard.instantiateInitialViewController() as! BusstopDetailViewController
        }()
        let router = BusstopDetailRouter(view: view)
        presenter = BusstopDetailPresenter(
            dependency: .init(
                viewData: viewData,
                router: router
            )
        )
        view.inject(.init(presenter: presenter))
    }
    
    func test_is_correctRowsNumber_InRoutesSection() {
        let actual = presenter.numberOfRowsInSection(section: 1)
        let expected = viewData.routes.count
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_check_busstopNameRow_atBusstopNameSection() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        
        let actualCellName = cell.textLabel?.text
        let expectedCellName = viewData.name
        XCTAssertEqual(expectedCellName, actualCellName)
        
        let actualAccessoryType = cell.accessoryType
        let expectedAccessoryType = UITableViewCell.AccessoryType.none
        XCTAssertEqual(expectedAccessoryType, actualAccessoryType)
        
        let actualSelectionStyle = cell.selectionStyle
        let expectedSelectionStyle = UITableViewCell.SelectionStyle.none
        XCTAssertEqual(expectedSelectionStyle, actualSelectionStyle)
    }
    
    func test_check_busstopRoutesRow_atBusstopRoutesSection() {
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        
        let actualCellName = cell.textLabel?.text
        let expectedCellName = viewData.routes[indexPath.row]
        XCTAssertEqual(expectedCellName, actualCellName)
        
        let actualCellDetail = cell.detailTextLabel?.text
        let expectedCellDetail = "[事業者名] \(viewData.organizations[indexPath.row])"
        XCTAssertEqual(expectedCellDetail, actualCellDetail)
        
        let actualAccessoryType = cell.accessoryType
        let expectedAccessoryType = UITableViewCell.AccessoryType.none
        XCTAssertEqual(expectedAccessoryType, actualAccessoryType)
        
        let actualSelectionStyle = cell.selectionStyle
        let expectedSelectionStyle = UITableViewCell.SelectionStyle.none
        XCTAssertEqual(expectedSelectionStyle, actualSelectionStyle)
    }
    
    func test_check_openWebpageRowProperty() {
        let indexPath = IndexPath(row: 0, section: 2)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        
        let actualAccessoryType = cell.accessoryType
        let expectedAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        XCTAssertEqual(expectedAccessoryType, actualAccessoryType)
    }
}

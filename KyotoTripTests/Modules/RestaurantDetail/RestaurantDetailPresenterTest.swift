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
        name: "鶏料理専門 金の鶏 京都駅本店",
        nameKana: "トリリョウリセンモンキンノトリ キョウトエキホンテン",
        address: "〒601-8011 京都府京都市南区東九条南山王町11.12.13-3",
        access: "ＪＲ京都駅八条口 徒歩3分  近鉄京都線京都駅 徒歩3分  地下鉄烏丸線京都駅 徒歩3分  地下鉄烏丸線九条駅 徒歩2分",
        tel: "050-3477-8987",
        businessHour: " ランチ：11:30～14:00(L.O.13:30)(※ランチは予約制となります。前日までにご予約をお願いいたします。)、ディナー：17:00～24:00(L.O.23:00)",
        holiday: "毎週水曜日",
        salesPoint: "4/1～名物「黄金の唐揚げ」300円(税抜)が付き出しに♪\nキャッシュレスで5％還元中！京都駅近の鶏料理専門居酒屋\n【何杯飲んでも生ビール100円＋コロナビール1本進呈】開催中\n看板メニューの黄金の唐揚げに最強メニュー「唐揚げ舟盛り」爆誕！\n創業時より変わらぬ秘伝タレで漬け込んだ大人気メニューをお値打ちにて\n\n◆歓送迎会ご予約承り中！\n「唐揚げ舟盛りプレゼント」など5つから選べる特典付♪\n不動の人気『カジュアルチーズタッカルビコース』2,980円\n当店人気No.1『金の鶏メドレーコース』4,500円など多数\n\n◆お昼宴会OK\n昼限定コースは2,000円ポッキリ♪通常コースも予約OKです\n◆個室完備\n全席掘りごたつでゆったり♪最大24名様までの個室をご用意いたします\n◆誕生日や記念日に\nメッセージ付プレートご用意OK！お祝いに最適な『サプライズコース』も♪",
        url: "https://r.gnavi.co.jp/k919817/?ak=7xCEgQ0qPWv67OFCR5GwQmCsheBZWA4wDSrI%2FYwuZHU%3D",
        imageUrl: "https://rimage.gnst.jp/rest/img/g8bt36y40000/t_0nbl.jpg?t=1590633018&rw=80&rh=80"
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
    
    func testCreateCellForNameSection() {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actualName = cell.textLabel?.text
        let expectedName = viewData.name
        let actualKanaName = cell.detailTextLabel?.text
        let expectedKanaName = viewData.nameKana
        
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedKanaName, actualKanaName)
    }
    
    func testCreateCellForAddressSection() {
        let indexPath = IndexPath(item: 0, section: 1)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actualAddress = cell.textLabel?.text
        let expectedAddress = viewData.address
        let actualAccess = cell.detailTextLabel?.text
        let expectedAccess = viewData.access
        
        
        XCTAssertEqual(expectedAddress, actualAddress)
        XCTAssertEqual(expectedAccess, actualAccess)
    }
    
    func testCreateCellForBusinessHourSection() {
        let indexPath = IndexPath(item: 0, section: 2)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.businessHour
        
        XCTAssertEqual(expected, actual)
    }
    
    func testCreateCellForHolidaySection() {
        let indexPath = IndexPath(item: 0, section: 3)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.holiday
        
        XCTAssertEqual(expected, actual)
    }
    
    func testCreateCellForTelSection() {
        let indexPath = IndexPath(item: 0, section: 4)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.tel
        
        XCTAssertEqual(expected, actual)
    }
    
    func testCreateCellForWebpageSection() {
        let indexPath = IndexPath(item: 0, section: 5)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.url
        
        XCTAssertEqual(expected, actual)
    }
    
    func testCreateCellForOtherSection() {
        let indexPath = IndexPath(item: 0, section: 6)
        let cell = presenter.createCellForRowAt(indexPath: indexPath)
        let actual = cell.textLabel?.text
        let expected = viewData.salesPoint
        
        XCTAssertEqual(expected, actual)
    }
    
    override func tearDown() {
    }
}

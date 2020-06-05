//
//  InfoPresenterTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
import SwiftyXMLParser
import RxSwift
import RxCocoa
@testable import KyotoTrip

class InfoPresenterTests: XCTestCase {
    
    private let kyotoCityInfoXML = """
    <rss version="2.0">
      <channel>
        <title>京都市:観光・文化・産業</title>
        <link>https://www.city.kyoto.lg.jp/menu2/</link>
        <description>京都市役所</description>
        <language>ja</language>
        <pubDate>Fri, 05 Jun 2020 14:00:40 +0900</pubDate>
        <copyright>(c) City of Kyoto. All rights reserved.</copyright>
        <docs>http://blogs.law.harvard.edu/tech/rss</docs>
        <managingEditor />
        <item>
          <title>京都市考古資料館特別展示「光秀と京～入京から本能寺の変～」の会期延長について </title>
          <link>https://www.city.kyoto.lg.jp/bunshi/page/0000270768.html</link>
          <description />
          <pubDate>Fri, 05 Jun 2020 10:00:00 +0900</pubDate>
        </item>
        <item>
          <title>京都市伝統産業つくり手支援事業補助金交付対象事業の募集について</title>
          <link>https://www.city.kyoto.lg.jp/sankan/page/0000270636.html</link>
          <description />
          <pubDate>Fri, 05 Jun 2020 08:00:00 +0900</pubDate>
        </item>
        <item>
          <title>市内農産物の放射性物質モニタリング検査について</title>
          <link>https://www.city.kyoto.lg.jp/sankan/page/0000164441.html</link>
          <description />
          <pubDate>Fri, 05 Jun 2020 00:00:00 +0900</pubDate>
        </item>
      </channel>
    </rss>
    """
    
    override func setUp() {
    }
    
    func test_check_fetchedViewData_whenSuccessed() {
        let cityInfoEntity = parsedKyotoCityInfo()
        let kyotoCityInfoGateway = KyotoCityInfoGatewayStub(result: .success(cityInfoEntity))
        let interactor = InfoInteractor(dependency: .init(kyotoCityInfoGateway: kyotoCityInfoGateway))
        let presenter = InfoPresenter(
            dependency: .init(
                interactor: interactor
            )
        )
        let disposeBag = DisposeBag()
        
        presenter.fetch()
        
        let functionAnswered = expectation(description: "asynchronous function")
        presenter.infoDriver.drive(onNext: { cells in
            XCTAssertEqual("京都市考古資料館特別展示「光秀と京～入京から本能寺の変～」の会期延長について ", cells[0].title)
            XCTAssertEqual("https://www.city.kyoto.lg.jp/bunshi/page/0000270768.html", cells[0].link)
            XCTAssertEqual("Fri, 05 Jun 2020 10:00:00 +0900", cells[0].publishDate)
            
            XCTAssertEqual("京都市伝統産業つくり手支援事業補助金交付対象事業の募集について", cells[1].title)
            XCTAssertEqual("https://www.city.kyoto.lg.jp/sankan/page/0000270636.html", cells[1].link)
            XCTAssertEqual("Fri, 05 Jun 2020 08:00:00 +0900", cells[1].publishDate)
            
            XCTAssertEqual("市内農産物の放射性物質モニタリング検査について", cells[2].title)
            XCTAssertEqual("https://www.city.kyoto.lg.jp/sankan/page/0000164441.html", cells[2].link)
            XCTAssertEqual("Fri, 05 Jun 2020 00:00:00 +0900", cells[2].publishDate)
            
            functionAnswered.fulfill()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
    }
}

private extension InfoPresenterTests {
    private func parsedKyotoCityInfo() -> [KyotoCityInfoEntity] {
        let parsedXML = try! XML.parse(kyotoCityInfoXML)
        var entityList: [KyotoCityInfoEntity] = []
        for element in parsedXML.rss.channel.item {
            var entity = KyotoCityInfoEntity()
            entity.title = element.title.text ?? ""
            entity.publishDate = element.pubDate.text ?? ""
            entity.link = element.link.text ?? ""
            entity.description = element["description"].text ?? ""
            
            entityList.append(entity)
        }
        return entityList
    }
}

//
//  InfoInteractorTests.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import XCTest
import SwiftyXMLParser
@testable import KyotoTrip

class InfoInteractorTests: XCTestCase {
    
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
    
    func test_check_fetchedKyotoCityInfo() {
        /// Build Interactor with stub for test
        let entityList = parsedKyotoCityInfo()
        let kyotoCityInfoGatewayStub = KyotoCityInfoGatewayStub(result: .success(entityList))
        let interactor = InfoInteractor(dependency: .init(kyotoCityInfoGateway: kyotoCityInfoGatewayStub))
        
        let functionAnswered = expectation(description: "asynchronous function")
        interactor.fetch { response in
            switch response {
            case .failure(_):
                print("")
            case .success(let kyotoCityInfo):
                XCTAssertEqual("京都市考古資料館特別展示「光秀と京～入京から本能寺の変～」の会期延長について ", kyotoCityInfo[0].title)
                XCTAssertEqual("https://www.city.kyoto.lg.jp/bunshi/page/0000270768.html", kyotoCityInfo[0].link)
                XCTAssertEqual("", kyotoCityInfo[0].description)
                XCTAssertEqual("Fri, 05 Jun 2020 10:00:00 +0900", kyotoCityInfo[0].publishDate)
            }
            
            functionAnswered.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    override func tearDown() {
    }
}

private extension InfoInteractorTests {
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

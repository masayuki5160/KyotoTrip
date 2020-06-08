//
//  KyotoCityInfoGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Alamofire
import SwiftyXMLParser

protocol KyotoCityInfoGatewayProtocol {
    func fetch(complition: @escaping (Result<[KyotoCityInfoEntity]>) -> Void)
}

struct KyotoCityInfoGateway: KyotoCityInfoGatewayProtocol {
    private let rssUrlStr = "https://www.city.kyoto.lg.jp/menu2/rss/rss.xml"

    func fetch(complition: @escaping (Result<[KyotoCityInfoEntity]>) -> Void) {
        Alamofire.request(rssUrlStr).responseData { response in
            var entityList: [KyotoCityInfoEntity] = []

            switch response.result {
            case .success(let data):

                let xml = XML.parse(data)
                for element in xml.rss.channel.item {
                    var entity = KyotoCityInfoEntity()
                    entity.title = element.title.text ?? ""
                    entity.publishDate = element.pubDate.text ?? ""
                    entity.link = element.link.text ?? ""
                    entity.description = element["description"].text ?? ""

                    entityList.append(entity)
                }

                complition(.success(entityList))

            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}

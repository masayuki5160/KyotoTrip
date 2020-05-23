//
//  KyotoCityInfoGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import SwiftyXMLParser
import Alamofire

protocol KyotoCityInfoGatewayProtocol: AnyObject {
    func fetch(commplition: @escaping (Result<[KyotoCityInfo]>) -> Void)
}

class KyotoCityInfoGateway: KyotoCityInfoGatewayProtocol {
    
    private let rssUrlStr = "https://www.city.kyoto.lg.jp/menu2/rss/rss.xml"
    
    init() {
    }
    
    func fetch(commplition: @escaping (Result<[KyotoCityInfo]>) -> Void) {
        Alamofire.request(rssUrlStr).responseData { response in
            
            var modelList: [KyotoCityInfo] = []
            
            switch response.result {
            case .success(let data):

                let xml = XML.parse(data)
                for element in xml.rss.channel.item {
                    var model = KyotoCityInfo()
                    model.title = element.title.text ?? ""
                    model.publishDate = element.pubDate.text ?? ""
                    model.link = element.link.text ?? ""
                    
                    modelList.append(model)
                }
                
                commplition(.success(modelList))

            case .failure(let error):
                commplition(.failure(error))
            }
            
        }
    }
}

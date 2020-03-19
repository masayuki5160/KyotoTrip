//
//  KyotoCityInfoViewModel.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/14.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyXMLParser
import Alamofire

class KyotoCityInfoViewModel {
    
    let rssUrlStr = "https://www.city.kyoto.lg.jp/menu2/rss/rss.xml"
    
    private let publishRelay = PublishRelay<[InfoTopPageTableViewCell]>()
    var subscribable: Observable<[InfoTopPageTableViewCell]> {
        return publishRelay.asObservable()
    }
    var disposeBag = DisposeBag()
    
    // TODO: 後で修正
    let data = Observable<[KyotoCityInfoModel]>.just([
        KyotoCityInfoModel(),
        KyotoCityInfoModel()
    ])
    
    init() {
//        // TODO: 後で削除(TEST用に追加)
//        Alamofire.request(rssUrlStr).responseData { (response) in
//            if let data = response.data {
//                let xml = XML.parse(data)
//                print(xml.rss.channel.item[0].title.text)
//                print(xml.rss.channel.item[0].link.text)
//                print(xml.rss.channel.item[0].pubDate.text)
//            }
//        }
    }
    
    public func update() {
        // TEST
        self.publishRelay.accept([InfoTopPageTableViewCell(),InfoTopPageTableViewCell()])
    }
}

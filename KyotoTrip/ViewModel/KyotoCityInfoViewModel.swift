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
    
    private let rssUrlStr = "https://www.city.kyoto.lg.jp/menu2/rss/rss.xml"
    
    private let modelListPublishRelay = PublishRelay<[KyotoCityInfoModel]>()
    var subscribableModelList: Observable<[KyotoCityInfoModel]> {
        return modelListPublishRelay.asObservable()
    }
    var disposeBag = DisposeBag()
    
    private var modelList: [KyotoCityInfoModel] = []
    
    init() {

        Alamofire.request(rssUrlStr).responseData { [weak self] (response) in
            if let data = response.data {
                let xml = XML.parse(data)

                for element in xml.rss.channel.item {
                    var model = KyotoCityInfoModel()
                    model.title = element.title.text ?? ""
                    model.publishDate = element.pubDate.text ?? ""
                    model.link = element.link.text ?? ""
                    
                    self?.modelList.append(model)
                }
                
                self?.modelListPublishRelay.accept(self?.modelList ?? [])
            }
        }
        
    }
    
    func modelList(index: Int) -> KyotoCityInfoModel {
        return modelList[index]
    }
    
}

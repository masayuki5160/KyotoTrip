//
//  KyotoCityInfoViewModel.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/14.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

struct KyotoCityInfoListViewModel {
    var kyotoCityInfoListVM: [KyotoCityInfoVM]
    
    init(_ kyotoCityInfoList: [KyotoCityInfoModel]) {
        kyotoCityInfoListVM = kyotoCityInfoList.compactMap(KyotoCityInfoVM.init)
    }
    
    func kyotoCityInfoListAt(_ index: Int) -> KyotoCityInfoVM {
        return kyotoCityInfoListVM[index]
    }
}

struct KyotoCityInfoVM {
    let kyotoCityInfoVM: KyotoCityInfoModel
    
    init(_ kyotoCityInfoModel: KyotoCityInfoModel) {
        self.kyotoCityInfoVM = kyotoCityInfoModel
    }
    
    var title: String {
        return kyotoCityInfoVM.title
    }
    
    var publishDate: String {
        return kyotoCityInfoVM.publishDate
    }
    
    var link: URL? {
        return URL(string: kyotoCityInfoVM.link)
    }
}

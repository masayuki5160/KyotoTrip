//
//  KyotoCityInfoList.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/29.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

struct KyotoCityInfoList {
    private var kyotoCityInfoList: [KyotoCityInfo]
    
    init(kyotoCityInfoList: [KyotoCityInfo]) {
        self.kyotoCityInfoList = kyotoCityInfoList
    }
    
    mutating func append(info: KyotoCityInfo) {
        kyotoCityInfoList = kyotoCityInfoList + [info]
    }
    
    subscript(index: Int) -> KyotoCityInfo {
        return kyotoCityInfoList[index]
    }
}

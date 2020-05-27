//
//  BusstopDetailEntity.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/27.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct BusstopDetailViewData {
    var name = ""
    var routes: [String] = []
    var organizations: [String] = []
    var routesDictionary: [String:String] {
        var dictionary: [String:String] = [:]
        
        for i in 0..<routes.count {
            dictionary[routes[i]] = organizations[i]
        }
        
        return dictionary
    }
}

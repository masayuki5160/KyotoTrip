//
//  CategoryButtonStatus.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/31.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

enum CategoryButtonStatus: Int {
    case hidden = 0
    case visible

    func next() -> Self {
        switch self {
        case .hidden: return .visible
        case .visible: return .hidden
        }
    }
}

//
//  StringExtension.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/20.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

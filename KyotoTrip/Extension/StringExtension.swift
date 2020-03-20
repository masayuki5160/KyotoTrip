//
//  StringExtension.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/20.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

extension String {
    // appendix: https://techblog.zozo.com/entry/ios-localization
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

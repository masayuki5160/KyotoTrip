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
        // swiftlint:disable nslocalizedstring_key
        NSLocalizedString(self, comment: "")
    }

    func replace(fromStr: String, toStr: String) -> String {
        var replacedString = self

        while replacedString.range(of: fromStr) != nil {
            if let range = replacedString.range(of: fromStr) {
                replacedString.replaceSubrange(range, with: toStr)
            }
        }

        return replacedString
    }
}

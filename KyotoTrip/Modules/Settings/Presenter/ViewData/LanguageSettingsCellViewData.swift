//
//  LanguageSettingsCellViewData.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

struct LanguageSettingsCellViewData {
    var language: LanguageSettings
    var title: String {
        language.toString()
    }
    var isSelect: Bool = false
}

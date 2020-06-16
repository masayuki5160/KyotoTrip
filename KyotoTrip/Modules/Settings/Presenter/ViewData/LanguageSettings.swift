//
//  LanguageSettings.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

enum LanguageSettings: String, CaseIterable {
    case japanese
    case english

    func toString() -> String {
        switch self {
        case .japanese: return "日本語"
        case .english: return "English"
        }
    }
}

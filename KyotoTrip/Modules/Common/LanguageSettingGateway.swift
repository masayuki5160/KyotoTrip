//
//  LanguageSettingGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/16.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation

protocol LanguageSettingGatewayProtocol {
    func fetch(complition: (Result<LanguageSettings, LanguageSettingGatewayError>) -> Void)
    func save(setting: LanguageSettings)
}

enum LanguageSettingGatewayError: Error {
    case entryNotFound
    case decodeError
}

struct LanguageSettingGateway: LanguageSettingGatewayProtocol {
    private let userdefaultsKey = "LanguageSetting"

    func fetch(complition: (Result<LanguageSettings, LanguageSettingGatewayError>) -> Void) {
        let settingEnumString = UserDefaults.standard.string(forKey: userdefaultsKey) ?? LanguageSettings.japanese.rawValue
        let settingEnum = LanguageSettings(rawValue: settingEnumString) ?? LanguageSettings.japanese

        complition(.success(settingEnum))
    }

    func save(setting: LanguageSettings) {
        UserDefaults.standard.set(setting.rawValue, forKey: userdefaultsKey)
    }
}

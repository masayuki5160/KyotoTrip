//
//  LanguageSettingGatewayStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/17.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
@testable import KyotoTrip

class LanguageSettingGatewayStub: LanguageSettingGatewayProtocol {
    private var result: Result<LanguageSettings, LanguageSettingGatewayError>

    init(result: Result<LanguageSettings, LanguageSettingGatewayError>) {
        self.result = result
    }

    func fetch(complition: (Result<LanguageSettings, LanguageSettingGatewayError>) -> Void) {
        complition(result)
    }

    func save(setting: LanguageSettings) {
    }
}

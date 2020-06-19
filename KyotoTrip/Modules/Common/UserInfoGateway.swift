//
//  UserInfoGateway.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/18.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

protocol UserInfoGatewayProtocol {
    func fetchLaunchedBefore(complition: (Result<Bool, UserInfoGatewayError>) -> Void)
    func save(launchedBefore: Bool)
}

enum UserInfoGatewayError: Error {
    case entryNotFound
    case decodeError
}

struct UserInfoGateway: UserInfoGatewayProtocol {
    private let userdefaultsIsFirstLaunchKey = "UserInfoLaunchedBefore"
    func fetchLaunchedBefore(complition: (Result<Bool, UserInfoGatewayError>) -> Void) {
        let launchedBefore = UserDefaults.standard.bool(forKey: userdefaultsIsFirstLaunchKey)
        complition(.success(launchedBefore))
    }

    func save(launchedBefore: Bool) {
        UserDefaults.standard.set(launchedBefore, forKey: userdefaultsIsFirstLaunchKey)
    }
}

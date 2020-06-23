//
//  UserInfoGatewayStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/20.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
@testable import KyotoTrip

class UserInfoGatewayStub: UserInfoGatewayProtocol {
    private let result: Result<Bool, UserInfoGatewayError>
    
    init(result: Result<Bool, UserInfoGatewayError>) {
        self.result = result
    }
    
    func fetchLaunchedBefore(complition: (Result<Bool, UserInfoGatewayError>) -> Void) {
        complition(result)
    }

    func save(launchedBefore: Bool) {
    }
}

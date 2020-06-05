//
//  KyotoCityInfoGatewayStub.swift
//  KyotoTripTests
//
//  Created by TANAKA MASAYUKI on 2020/06/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
@testable import KyotoTrip
import Alamofire

class KyotoCityInfoGatewayStub: KyotoCityInfoGatewayProtocol {
    private let result: Result<[KyotoCityInfoEntity]>

    init(result: Result<[KyotoCityInfoEntity]>) {
        self.result = result
    }
    func fetch(complition: @escaping (Result<[KyotoCityInfoEntity]>) -> Void) {
        complition(result)
    }
}

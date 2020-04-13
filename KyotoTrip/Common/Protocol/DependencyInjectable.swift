//
//  DependencyInjectable.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation

protocol DependencyInjectable {
    associatedtype Dependency
    func inject(_ dependency: Dependency)
}

//
//  Application.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/02.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class Application {
    static let shared = Application()
    private init() {}
    
    private(set) var useCase: KyotoCityInfoUseCase!
    
    func configure(with window: UIWindow) {
        buildLayer()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    private func buildLayer() {
        
        // -- Use Case
        useCase = KyotoCityInfoUseCase()
        
        // -- Interface Adapters
        
        // Use Caseとのバインド
        
        // -- Framework & Drivers
        
        // Interface Adaptersとのバインド
        
        // Presenterの作成・バインドは各ViewControllerを生成するクラスが実施
        // (本プロジェクトではTabBarControllerのawakeFromNib())
    }
}

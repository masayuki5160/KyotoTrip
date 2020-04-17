//
//  AppDependencies.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/12.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//


import UIKit

protocol AppDependencies {
    func assembleMainTabModule() -> UIViewController
    func assembleSettingsModule() -> UINavigationController
    func assembleKyotoInfoTopModule() -> UINavigationController
    func assembleKyotoMapModule() -> UINavigationController
}

public struct AppDefaultDependencies {

    public init() {}

    public func rootViewController() -> UIViewController {
        return assembleMainTabModule()
    }
}

extension AppDefaultDependencies: AppDependencies {
    
    func assembleMainTabModule() -> UIViewController {
        let viewController = {() -> TabBarController in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            return storyboard.instantiateInitialViewController() as! TabBarController
        }()
        
        return viewController
    }
    
    func assembleSettingsModule() -> UINavigationController {
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let navVC = storyboard.instantiateInitialViewController() as! UINavigationController
            let vc = navVC.viewControllers[0] as! SettingsViewController
            vc.inject(.init())

            return navVC
        }()
        
        return naviViewController
    }
    
    func assembleKyotoInfoTopModule() -> UINavigationController {
        
        let interactor = KyotoCityInfoInteractor()
        let presenter = KyotoCityInfoPresenter(
            dependency: .init(
                interactor: interactor
            )
        )
        
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Info", bundle: nil)
            let navVC = storyboard.instantiateInitialViewController() as! UINavigationController
            let vc = navVC.viewControllers[0] as! InfoTopPageViewController
            vc.inject(.init(presenter: presenter))
            
            return navVC
        }()
        
        return naviViewController
    }
    
    func assembleKyotoMapModule() -> UINavigationController {
        
        let interactor = KyotoMapInteractor()
        let presenter = KyotoMapPresenter(
            dependency: .init(
                interactor: interactor
            )
        )
        
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            let navVC = storyboard.instantiateInitialViewController() as! UINavigationController
            let vc = navVC.viewControllers[0] as! MapViewController
            vc.inject(.init(presenter: presenter))
            
            return navVC
        }()
        
        return naviViewController
    }
}

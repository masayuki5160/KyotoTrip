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
    func assembleBusstopDetailModule() -> UIViewController
    func assembleCulturalPropertyDetailModule() -> UIViewController
    func assembleRestaurantDetailModule() -> UIViewController
    func assembleCategoryModule() -> UIViewController
    func assembleSettingsLisenceModule() -> UIViewController
    func assembleSettingsRestaurantsSearchModule() -> UIViewController
    func assembleSettingsRestaurantsSearchRangeModule() -> UIViewController
}

public struct AppDefaultDependencies {

    public init() {}

    public func rootViewController() -> UIViewController {
        return assembleMainTabModule()
    }
}

extension AppDefaultDependencies: AppDependencies {
    func assembleMainTabModule() -> UIViewController {
        return TabBarController()
    }
    
    func assembleSettingsModule() -> UINavigationController {
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        let vc = naviViewController.viewControllers[0] as! SettingsViewController
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter(dependency: .init(interactor: interactor))
        vc.inject(.init(presenter: presenter))
        
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
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        let vc = naviViewController.viewControllers[0] as! InfoTopPageViewController
        vc.inject(.init(presenter: presenter))
        
        return naviViewController
    }
    
    func assembleKyotoMapModule() -> UINavigationController {
        
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        let view = naviViewController.viewControllers[0] as! MapViewController
        
        let interactor = MapInteractor()
        let commonPresenter = CommonMapPresenter.shared
        let router = MapViewRouter(view: view)
        let presenter = MapPresenter(
            dependency: .init(
                interactor: interactor,
                commonPresenter: commonPresenter,
                router: router
            )
        )
        view.inject(.init(presenter: presenter))
        
        return naviViewController
    }
    
    func assembleBusstopDetailModule() -> UIViewController {
        let view = { () -> BusstopDetailViewController in
            let storyboard = UIStoryboard(name: "BusstopDetail", bundle: nil)
            return storyboard.instantiateInitialViewController() as! BusstopDetailViewController
        }()
        
        return view
    }
    
    func assembleCulturalPropertyDetailModule() -> UIViewController {
        let view = { () -> CulturalPropertyDetailViewController in
            let storyboard = UIStoryboard(name: "CulturalPropertyDetail", bundle: nil)
            return storyboard.instantiateInitialViewController() as! CulturalPropertyDetailViewController
        }()
        
        return view
    }
    
    func assembleCategoryModule() -> UIViewController {
        let view = { () -> CategoryViewController in
            let storyboard = UIStoryboard(name: "Category", bundle: nil)
            return storyboard.instantiateInitialViewController() as! CategoryViewController
        }()
        
        let interactor = CategoryInteractor()
        let commonPresenter = CommonMapPresenter.shared
        let presenter = CategoryPresenter(dependency: .init(
            interactor: interactor,
            commonPresenter: commonPresenter)
        )
        view.inject(.init(presenter: presenter))
        
        return view
    }
    
    func assembleRestaurantDetailModule() -> UIViewController {
        let view = { () -> RestaurantDetailViewController in
            let storyboard = UIStoryboard(name: "RestaurantDetail", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantDetailViewController
        }()
        
        return view
    }
    
    func assembleSettingsLisenceModule() -> UIViewController {
        let view = { () -> SettingsLicenseViewController in
            let storyboard = UIStoryboard(name: "SettingsLicense", bundle: nil)
            return storyboard.instantiateInitialViewController() as! SettingsLicenseViewController
        }()
        
        return view
    }

    func assembleSettingsRestaurantsSearchModule() -> UIViewController {
        let view = { () -> RestaurantsSearchSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearch", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchSettingsViewController
        }()

        let interactor = RestaurantsSearchSettingsInteractor()
        let router = RestaurantsSearchSettingsRouter(view: view)
        let commonPresenter = CommonSettingsPresenter()
        let presenter = RestaurantsSearchSettingsPresenter(dependency: .init(
            interactor: interactor,
            router: router,
            commonPresenter: commonPresenter)
        )
        view.inject(.init(presenter: presenter))
        
        return view
    }
    
    func assembleSettingsRestaurantsSearchRangeModule() -> UIViewController {
        let view = { () -> RestaurantsSearchRangeSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearchRange", bundle: nil)
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchRangeSettingsViewController
        }()

        let interactor = RestaurantsSearchRangeSettingInteractor()
        let router = RestaurantsSearchRangeSettingRouter(view: view)
        let commonPresenter = CommonSettingsPresenter()
        let presenter = RestaurantsSearchRangeSettingPresenter(dependency: .init(
            interactor: interactor,
            router: router,
            commonPresenter: commonPresenter)
        )
        view.inject(.init(presenter: presenter))
        
        return view
    }
}

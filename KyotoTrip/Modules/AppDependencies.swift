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
    func assembleBusstopDetailModule(inject viewData: BusstopDetailViewData) -> UIViewController
    func assembleCulturalPropertyDetailModule(inject viewData: CulturalPropertyDetailViewData) -> UIViewController
    func assembleRestaurantDetailModule(inject viewData: RestaurantDetailViewData) -> UIViewController
    func assembleCategoryModule(inject interactor: MapInteractor) -> UIViewController
    func assembleSettingsLisenceModule() -> UIViewController
    func assembleSettingsRestaurantsSearchModule(inject interactor: SettingsInteractorProtocol) -> UIViewController
    func assembleSettingsRestaurantsSearchRangeModule(inject interactor: SettingsInteractorProtocol) -> UIViewController
    func assembleLanguagesSettingsModule(inject interactor: SettingsInteractorProtocol) -> UIViewController
    func assembleFamousSitesDetailModule(inject viewData: FamousSitesDetailViewData) -> UIViewController
}

struct AppDefaultDependencies {
    public init() {}
    public func rootViewController() -> UIViewController {
        assembleMainTabModule()
    }
}

extension AppDefaultDependencies: AppDependencies {
    func assembleMainTabModule() -> UIViewController {
        TabBarController()
    }

    func assembleSettingsModule() -> UINavigationController {
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        let vc = naviViewController.viewControllers[0] as! SettingsViewController
        let restaurntRequestParamGateway = RestaurantsRequestParamGateway()
        let languageSettingGateway = LanguageSettingGateway()
        let interactor = SettingsInteractor(dependency: .init(
            restaurantsRequestParamGateway: restaurntRequestParamGateway,
            languageSettingGateway: languageSettingGateway
        )
        )
        let router = SettingsRouter(view: vc)
        let presenter = SettingsPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )
        vc.inject(.init(presenter: presenter))

        return naviViewController
    }

    func assembleKyotoInfoTopModule() -> UINavigationController {
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Info", bundle: nil)
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        let view = naviViewController.viewControllers[0] as! InfoViewController
        let kyotoCityInfoGateway = KyotoCityInfoGateway()
        let languageSettingGateway = LanguageSettingGateway()
        let interactor = InfoInteractor(dependency: .init(
            kyotoCityInfoGateway: kyotoCityInfoGateway,
            languageSettingGateway: languageSettingGateway
        )
        )
        let router = InfoRouter(view: view)
        let presenter = InfoPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )
        view.inject(.init(presenter: presenter))

        return naviViewController
    }

    func assembleKyotoMapModule() -> UINavigationController {
        let naviViewController = { () -> UINavigationController in
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! UINavigationController
        }()
        let view = naviViewController.viewControllers[0] as! MapViewController

        let restaurantsSearchGateway = RestaurantsSearchGateway()
        let requestParamGateway = RestaurantsRequestParamGateway()
        let languageSettingGateway = LanguageSettingGateway()
        let userInfoGateway = UserInfoGateway()
        let interactor = MapInteractor(
            dependency: .init(
                searchGateway: restaurantsSearchGateway,
                requestParamGateway: requestParamGateway,
                languageSettingGateway: languageSettingGateway,
                userInfoGateway: userInfoGateway
            )
        )
        let router = MapRouter(view: view)
        let presenter = MapPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )

        let categoryView = assembleCategoryModule(inject: interactor)
        let mglFeatureMediator = MGLFeatureMediator(
            dependency: .init(
                presenter: presenter
            )
        )
        view.inject(
            .init(
                presenter: presenter,
                categoryView: categoryView,
                mglFeatureMediator: mglFeatureMediator
            )
        )

        return naviViewController
    }

    func assembleBusstopDetailModule(inject viewData: BusstopDetailViewData) -> UIViewController {
        let view = { () -> BusstopDetailViewController in
            let storyboard = UIStoryboard(name: "BusstopDetail", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! BusstopDetailViewController
        }()
        let router = BusstopDetailRouter(view: view)
        let presenter = BusstopDetailPresenter(
            dependency: .init(
                viewData: viewData,
                router: router
            )
        )
        view.inject(.init(presenter: presenter))

        return view
    }

    func assembleCulturalPropertyDetailModule(inject viewData: CulturalPropertyDetailViewData) -> UIViewController {
        let view = { () -> CulturalPropertyDetailViewController in
            let storyboard = UIStoryboard(name: "CulturalPropertyDetail", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! CulturalPropertyDetailViewController
        }()
        let router = CulturalPropertyDetailRouter(view: view)
        let presenter = CulturalPropertyDetailPresenter(
            dependency: .init(
                router: router,
                viewData: viewData
            )
        )
        view.inject(.init(presenter: presenter))

        return view
    }

    func assembleRestaurantDetailModule(inject viewData: RestaurantDetailViewData) -> UIViewController {
        let view = { () -> RestaurantDetailViewController in
            let storyboard = UIStoryboard(name: "RestaurantDetail", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! RestaurantDetailViewController
        }()
        let router = RestaurantDetailRouter(view: view)
        let presenter = RestaurantDetailPresenter(
            dependency: .init(
                router: router,
                viewData: viewData
            )
        )
        view.inject(.init(presenter: presenter))

        return view
    }

    func assembleSettingsLisenceModule() -> UIViewController {
        let view = { () -> SettingsLicenseViewController in
            let storyboard = UIStoryboard(name: "SettingsLicense", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! SettingsLicenseViewController
        }()

        return view
    }

    func assembleSettingsRestaurantsSearchModule(inject interactor: SettingsInteractorProtocol) -> UIViewController {
        let view = { () -> RestaurantsSearchSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearch", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchSettingsViewController
        }()

        let router = RestaurantsSearchSettingsRouter(view: view)
        let presenter = RestaurantsSearchSettingsPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )
        view.inject(.init(presenter: presenter))

        return view
    }

    func assembleSettingsRestaurantsSearchRangeModule(inject interactor: SettingsInteractorProtocol) -> UIViewController {
        let view = { () -> RestaurantsSearchRangeSettingsViewController in
            let storyboard = UIStoryboard(name: "SettingsRestaurantsSearchRange", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! RestaurantsSearchRangeSettingsViewController
        }()

        let router = RestaurantsSearchRangeSettingRouter(view: view)
        let presenter = RestaurantsSearchRangeSettingPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )
        view.inject(.init(presenter: presenter))

        return view
    }

    func assembleCategoryModule(inject interactor: MapInteractor) -> UIViewController {
        let view = { () -> CategoryViewController in
            let storyboard = UIStoryboard(name: "Category", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! CategoryViewController
        }()

        let router = CategoryRouter(view: view)
        let presenter = CategoryPresenter(
            dependency: .init(
                interactor: interactor,
                router: router
            )
        )
        view.inject(.init(presenter: presenter))

        return view
    }

    func assembleLanguagesSettingsModule(inject interactor: SettingsInteractorProtocol) -> UIViewController {
        let view = { () -> LanguageSettingsViewController in
            let storyboard = UIStoryboard(name: "LanguageSettings", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! LanguageSettingsViewController
        }()

        let presenter = LanguageSettingsPresenter(dependency: .init(interactor: interactor))
        view.inject(.init(presenter: presenter))

        return view
    }

    func assembleFamousSitesDetailModule(inject viewData: FamousSitesDetailViewData) -> UIViewController {
        let view = { () -> FamousSitesDetailViewController in
            let storyboard = UIStoryboard(name: "FamousSitesDetail", bundle: nil)
            // swiftlint:disable force_cast
            return storyboard.instantiateInitialViewController() as! FamousSitesDetailViewController
        }()

        let router = FamousSitesDetailRouter(view: view)
        let presenter = FamousSitesDetailPresenter(
            dependency: .init(
                router: router,
                viewData: viewData
            )
        )
        view.inject(.init(presenter: presenter))

        return view
    }
}

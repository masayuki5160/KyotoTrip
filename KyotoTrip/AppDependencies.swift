//
//  AppDependencies.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/12.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//


import UIKit

protocol AppDependencies {
//    func assembleGithubRepoDetailModule(githubRepoEntity: GithubRepoEntity) -> UIViewController
    func assembleMainTabModule() -> UIViewController
    func assembleSettingsModule() -> UIViewController
    func assembleKyotoInfoTopModule() -> UIViewController
    func assembleKyotoMapModule() -> UIViewController
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
    
    func assembleSettingsModule() -> UIViewController {
        let viewController = { () -> SettingsViewController in
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            return storyboard.instantiateInitialViewController() as! SettingsViewController
        }()
        
        return viewController
    }
    
    func assembleKyotoInfoTopModule() -> UIViewController {
        
        let interactor = KyotoCityInfoInteractor()
        let presenter = KyotoCityInfoPresenter(
            dependency: .init(
                interactor: interactor
            )
        )
        
        let viewController = { () -> InfoTopPageViewController in
            let storyboard = UIStoryboard(name: "Info", bundle: nil)
            return storyboard.instantiateInitialViewController() as! InfoTopPageViewController
        }()
        viewController.inject(.init(presenter: presenter))
        
        return viewController
    }
    
    func assembleKyotoMapModule() -> UIViewController {
        let viewController = { () -> MapViewController in
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            return storyboard.instantiateInitialViewController() as! MapViewController
        }()
        
        // TODO: ViewControllerへのDI実施
        
        return viewController
    }

    
//    public func assembleGithubRepoSearchModule() -> UIViewController {
//        let viewController = { () -> GithubRepoSearchViewController in
//            let storyboard = UIStoryboard(name: "GithubRepoSearch", bundle: bundle)
//            return storyboard.instantiateInitialViewController() as! GithubRepoSearchViewController
//        }()
//
//        let router = GithubRepoSearchRouter(
//            appDependencies: self,
//            searchViewController: viewController
//        )
//
//        let presenter = GithubRepoSearchPresenter(
//            view: viewController,
//            dependency: .init(
//                wireframe: router,
//                githubRepoRecommend: AnyUseCase(GithubRepoRecommendInteractor()),
//                githubRepoSearch: AnyUseCase(GithubRepoSearchInteractor()),
//                githubRepoSort: AnyUseCase(GithubRepoSortInteractor())
//            )
//        )
//
//        viewController.inject(.init(presenter: presenter))
//
//        return viewController
//    }

//    func assembleGithubRepoDetailModule(githubRepoEntity: GithubRepoEntity) -> UIViewController {
//
//        let viewController = { () -> GithubRepoDetailViewController in
//            let storyboard = UIStoryboard(name: "GithubRepoDetail", bundle: bundle)
//            return storyboard.instantiateInitialViewController() as! GithubRepoDetailViewController
//        }()
//
//        let router = GithubRepoDetailRouter(
//            detailViewController: viewController
//        )
//
//        let presenter = GithubRepoDetailPresenter(wireframe: router, view: viewController)
//        viewController.inject(.init(presenter: presenter, githubRepoEntity: githubRepoEntity))
//
//        return viewController
//    }
}

//
//  TransitionerProtocol.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

/// Reference from https://github.com/peaks-cc/iOS_architecture_samplecode/tree/master/12
protocol TransitionerProtocol where Self: UIViewController {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool)
    func popToRootViewController(animated: Bool)
    func popToViewController(_ viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool)
}

extension TransitionerProtocol {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        /// TODO: navigationControllerがnilのときの処理追加?
        guard let naviViewController = navigationController else { return }
        naviViewController.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool) {
    }

    func popToRootViewController(animated: Bool) {
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool) {
    }

    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool) {
        dismiss(animated: animated)
    }
}

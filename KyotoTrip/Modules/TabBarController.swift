//
//  TabBarController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/02.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import AppTrackingTransparency

class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let infoTopViewController = AppDefaultDependencies().assembleKyotoInfoTopModule()
        let mapViewController = AppDefaultDependencies().assembleKyotoMapModule()
        let settingViewController = AppDefaultDependencies().assembleSettingsModule()
        let bookmarksViewController = AppDefaultDependencies().assembleBookmarksModule()

        self.viewControllers = [mapViewController, infoTopViewController, bookmarksViewController, settingViewController]

        //        if #available(iOS 14, *) {
        //            ATTrackingManager.requestTrackingAuthorization { _ in }
        //        }
    }
}

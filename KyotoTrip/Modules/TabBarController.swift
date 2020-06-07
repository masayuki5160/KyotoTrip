//
//  TabBarController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/02.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let infoTopViewController = AppDefaultDependencies().assembleKyotoInfoTopModule()
        let mapViewController = AppDefaultDependencies().assembleKyotoMapModule()
        let settingViewController = AppDefaultDependencies().assembleSettingsModule()

        self.viewControllers = [mapViewController, infoTopViewController, settingViewController]
    }
}

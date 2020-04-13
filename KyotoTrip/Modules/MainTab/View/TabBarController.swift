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
    }
    
    override func viewDidLoad() {
        let infoTopViewController = AppDefaultDependencies().assembleKyotoInfoTopModule()
        let mapViewController = AppDefaultDependencies().assembleKyotoMapModule()
        
        self.viewControllers = [infoTopViewController, mapViewController]
    }
}

//
//  SettingsLicenseViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import SafariServices
import UIKit

class SettingsLicenseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "ライセンス"
        let url = URL(string: "https://masaytan.com/kyoto-trip-license")
        if let url = url {
            self.present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
}

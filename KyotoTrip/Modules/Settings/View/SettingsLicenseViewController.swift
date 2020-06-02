//
//  SettingsLicenseViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class SettingsLicenseViewController: UIViewController {

    struct Dependency {
    }
    private var dependency: Dependency!

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ライセンス"
        textView.isEditable = false
        textView.text = """
        本アプリケーションは以下のオープンソースソフトウェアを使用しています。
        
        ■hoge
        
        ■hoge
        
        ■hoge
        """
    }
}

extension SettingsLicenseViewController: DependencyInjectable {
    func inject(_ dependency: SettingsLicenseViewController.Dependency) {
        self.dependency = dependency
    }
}

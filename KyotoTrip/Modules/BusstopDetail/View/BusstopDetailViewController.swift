//
//  BusstopDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/22.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class BusstopDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "BusstopDetailTitle".localized
    }
}

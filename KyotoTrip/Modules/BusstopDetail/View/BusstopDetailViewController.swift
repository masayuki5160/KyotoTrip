//
//  BusstopDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/22.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class BusstopDetailViewController: UIViewController, DetailViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    var visibleFeatureEntity: MarkerEntityProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "BusstopDetailTitle".localized
    }
}

//
//  CategoryViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }
}

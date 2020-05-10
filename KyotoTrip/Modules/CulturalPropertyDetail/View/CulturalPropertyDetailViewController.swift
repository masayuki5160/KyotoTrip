//
//  CulturalPropertyDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class CulturalPropertyDetailViewController: UIViewController, DetailViewProtocol {

    var visibleFeatureEntity: VisibleFeatureProtocol!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let entity = visibleFeatureEntity as! CulturalPropertyFeatureEntity
        name.text = entity.title
        address.text = entity.address
    }
}

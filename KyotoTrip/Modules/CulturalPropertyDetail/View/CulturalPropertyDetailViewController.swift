//
//  CulturalPropertyDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class CulturalPropertyDetailViewController: UIViewController, DetailViewProtocol {

    var markerEntity: MarkerEntityProtocol!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var largeClassification: UILabel!
    @IBOutlet weak var smallClassification: UILabel!
    @IBOutlet weak var registerDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let entity = markerEntity as! CulturalPropertyMarkerEntity
        name.text = entity.title
        address.text = entity.address
        largeClassification.text = entity.largeClassification
        smallClassification.text = entity.smallClassification
        registerDate.text = entity.registerDateString
    }
}

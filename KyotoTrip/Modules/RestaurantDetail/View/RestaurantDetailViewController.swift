//
//  RestaurantDetailViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, DetailViewProtocol {
    var visibleFeatureEntity: MarkerEntityProtocol!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantKanaName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var buisinessHour: UILabel!
    @IBOutlet weak var holiday: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let entity = visibleFeatureEntity as! RestaurantFeatureEntity
        restaurantName.text = entity.detail?.name.name
        restaurantKanaName.text = entity.detail?.name.nameKana
        address.text = entity.detail?.contacts.address
        buisinessHour.text = entity.detail?.businessHour
        holiday.text = entity.detail?.holiday
    }
}

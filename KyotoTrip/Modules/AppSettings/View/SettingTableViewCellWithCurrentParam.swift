//
//  SettingTableViewCellWithCurrentParam.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/14.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class SettingTableViewCellWithCurrentParam: UITableViewCell {
    
    static let id = "SettingTableViewCellWithCurrentParam"
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var currentParam: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//
//  SettingTableViewCellWithSwitch.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/14.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class SettingTableViewCellWithSwitch: UITableViewCell {

    static let id = "SettingTableViewCellWithSwitch"
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func tappedSwitch(_ sender: UISwitch) {
        print("Switch status => \(sender.isOn)")
    }
    
}

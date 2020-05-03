//
//  CategoryTableViewCell.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/04/30.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

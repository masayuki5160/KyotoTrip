//
//  InfoTopPageViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import SegementSlide

class InfoTopPageViewController: UITableViewController, SegementSlideContentScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc var scrollView: UIScrollView {
        return tableView
    }
    
}

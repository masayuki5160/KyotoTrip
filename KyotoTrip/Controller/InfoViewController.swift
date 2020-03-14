//
//  InforViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import SegementSlide

class InfoViewController: SegementSlideViewController {
    
    let pages = ["TOP", "EVENT"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        scrollToSlide(at: 0, animated: true)
    }
    
//    override var headerView: UIView? {
//        let headerView = UIView()
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.heightAnchor.constraint(equalToConstant: view.bounds.height/4).isActive = true
//
//        return headerView
//    }
    
    override var titlesInSwitcher: [String] {
        return pages
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch index {
        case 0:
            return InfoTopPageViewController()
        case 1:
            return EventPageViewController()
        default:
            return InfoTopPageViewController()
        }
    }
}

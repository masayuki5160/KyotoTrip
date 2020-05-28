//
//  RestaurantDetailPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation
import UIKit

protocol RestaurantDetailPresenterProtocol {
    var sectionTitles: [String] { get }
    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell
    func numberOfRowsInSection(section: Int) -> Int
    func didSelectRowAt(indexPath: IndexPath)
}

class RestaurantDetailPresenter: RestaurantDetailPresenterProtocol {
    
    struct Dependency {
        let router: RestaurantDetailRouterProtocol
        let viewData: RestaurantDetailViewData
    }
    
    var sectionTitles = [
        "店舗名",
        "住所",
        "営業時間",
        "休業日"
    ]
    
    private var dependency: Dependency
    private let reuseCellId = "RestaurantDetailCell"
    
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseCellId)
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:// 店舗名
            cell.textLabel?.text = dependency.viewData.name
            cell.textLabel?.numberOfLines = 0
        case 1:// 住所
            cell.textLabel?.text = dependency.viewData.address
            cell.textLabel?.numberOfLines = 0
        case 2:// 営業時間
            cell.textLabel?.text = dependency.viewData.businessHour
            cell.textLabel?.numberOfLines = 0
        case 3:// 休業日
            cell.textLabel?.text = dependency.viewData.holiday
            cell.textLabel?.numberOfLines = 0
        default:
            break
        }
        
        return cell
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 1
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
    }

}

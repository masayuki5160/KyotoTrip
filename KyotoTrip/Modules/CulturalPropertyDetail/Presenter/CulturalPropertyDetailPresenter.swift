//
//  CulturalPropertyDetailPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/28.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation
import UIKit

protocol CulturalPropertyDetailPresenterProtocol {
    var sectionTitles: [String] { get }
    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell
    func numberOfRowsInSection(section: Int) -> Int
}

class CulturalPropertyDetailPresenter: CulturalPropertyDetailPresenterProtocol {
    
    struct Dependency {
        let router: CulturalPropertyDetailRouterProtocol
        let viewData: CulturalPropertyDetailViewData
    }
    
    let sectionTitles = [
        "都道府県指定文化財名称",
        "住所",
        "種別大区分",
        "種別小区分",
        "指定年月日"
    ]
    
    private var dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CulturalPropertyCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:// 都道府県指定文化財名称
            cell.textLabel?.text = dependency.viewData.name
        case 1:// 住所
            cell.textLabel?.text = dependency.viewData.address
        case 2:// 種別大区分
            cell.textLabel?.text = dependency.viewData.largeClassification
        case 3:// 種別小区分
            cell.textLabel?.text = dependency.viewData.smallClassification
        case 4:// 指定年月日
            cell.textLabel?.text = dependency.viewData.registerdDate
        default:
            break
        }
        
        return cell
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 1
    }
}

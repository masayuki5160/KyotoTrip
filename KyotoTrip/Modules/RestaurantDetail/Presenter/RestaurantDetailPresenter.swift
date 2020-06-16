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
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath)
}

class RestaurantDetailPresenter: RestaurantDetailPresenterProtocol {
    struct Dependency {
        let router: RestaurantDetailRouterProtocol
        let viewData: RestaurantDetailViewData
    }

    var sectionTitles = [
        "RestaurantDetailPageName".localized,
        "RestaurantDetailPageAddress".localized,
        "RestaurantDetailPageBuisinessHour".localized,
        "RestaurantDetailPageHoliday".localized,
        "RestaurantDetailPageTel".localized,
        "RestaurantDetailPageWebsite".localized,
        "RestaurantDetailPageOtherInfo".localized
    ]

    private var dependency: Dependency
    private let reuseCellId = "RestaurantDetailCell"

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: reuseCellId)

        switch indexPath.section {
        case 0:// 店舗名
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseCellId)
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.textLabel?.text = dependency.viewData.name
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = dependency.viewData.nameKana
            cell.detailTextLabel?.numberOfLines = 0

        case 1:// 住所
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseCellId)
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.textLabel?.text = dependency.viewData.address
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = dependency.viewData.access
            cell.detailTextLabel?.numberOfLines = 0

        case 2:// 営業時間
            cell.textLabel?.text = dependency.viewData.businessHour
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.textLabel?.numberOfLines = 0

        case 3:// 休業日
            cell.textLabel?.text = dependency.viewData.holiday
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.textLabel?.numberOfLines = 0

        case 4:// TEL
            cell.textLabel?.text = dependency.viewData.tel
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .none

        case 5:// ホームページ
            cell.textLabel?.text = dependency.viewData.url
            cell.textLabel?.numberOfLines = 0
            cell.accessoryType = .disclosureIndicator

        case 6:// その他
            cell.textLabel?.text = dependency.viewData.salesPoint
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.textLabel?.numberOfLines = 0

        default:
            break
        }

        return cell
    }

    func numberOfRowsInSection(section: Int) -> Int { 1 }

    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch indexPath.section {
        case 4:// TELセクション
            let phoneString = cell?.textLabel?.text ?? ""
            dependency.router.openPhoneApp(phoneNumber: phoneString.replace(fromStr: "-", toStr: ""))

        case 5:// URLセクション
            let urlString = cell?.textLabel?.text
            if let urlString = urlString, let url = URL(string: urlString) {
                dependency.router.presentRestaurantWebsite(url: url)
            }

        default:
            break
        }
    }
}

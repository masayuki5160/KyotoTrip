//
//  BusstopDetailPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/27.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import Foundation
import UIKit

protocol BusstopDetailPresenterProtocol {
    var sectionTitles: [String] { get }

    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell
    func numberOfRowsInSection(section: Int) -> Int
    func didSelectRowAt(indexPath: IndexPath)
}

class BusstopDetailPresenter: BusstopDetailPresenterProtocol {
    struct Dependency {
        let viewData: BusstopDetailViewData
        let router: BusstopDetailRouterProtocol
    }

    let sectionTitles = [
        "バス停名称",
        "路線(系統)",
        "" // バスの乗り方
    ]

    private var dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        switch indexPath.section {
        case 0:// バス停名称
            cell = UITableViewCell(style: .default, reuseIdentifier: "BusstopNameCell")
            cell.textLabel?.text = dependency.viewData.name
            cell.accessoryType = .none
            cell.selectionStyle = .none

        case 1:// 路線
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "BusRouteCell")
            cell.textLabel?.text = dependency.viewData.routes[indexPath.row]
            cell.detailTextLabel?.text = "[事業者名] " + dependency.viewData.organizations[indexPath.row]
            cell.accessoryType = .none
            cell.selectionStyle = .none

        case 2:// バスの乗り方
            cell = UITableViewCell(style: .default, reuseIdentifier: "BusstopSettingCell")
            cell.textLabel?.text = "バスの乗り方"
            cell.accessoryType = .disclosureIndicator

        default:
            cell = UITableViewCell(style: .default, reuseIdentifier: "BusstopSettingCell")
        }

        return cell
    }

    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1

        case 1:
            return dependency.viewData.routes.count

        case 2:
            return 1

        default:
            return 1
        }
    }

    func didSelectRowAt(indexPath: IndexPath) {
        if indexPath.section == 2 {// バスの作り方セクション
            dependency.router.presentHowToUseBusWebsite()
        }
    }
}

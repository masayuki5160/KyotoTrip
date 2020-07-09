//
//  FamousSitesDetailPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/07/05.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import UIKit

protocol FamousSitesDetailPresenterProtocol {
    var sectionTitles: [String] { get }

    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell
    func numberOfRowsInSection(section: Int) -> Int
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath)
}

class FamousSitesDetailPresenter: FamousSitesDetailPresenterProtocol {
    struct Dependency {
        let router: FamousSitesDetailRouterProtocol
        let viewData: FamousSitesDetailViewData
    }

    private let dependency: Dependency

    init(dependency: Dependency) {
        self.dependency = dependency
    }

    let sectionTitles = [
        "FamousSitesDetailPageName".localized,
        "Facebook",
        "Twitter",
        "Instagram",
        "Youtube",
        "Website"
    ]

    func createCellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "FamousSitesCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = dependency.viewData.name

        case 1:// Facebook
            if dependency.viewData.facebook.isEmpty {
                cell.textLabel?.text = "-"
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
                cell.textLabel?.text = dependency.viewData.facebook
            }

        case 2:// Twitter
            if dependency.viewData.twitter.isEmpty {
                cell.textLabel?.text = "-"
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
                cell.textLabel?.text = dependency.viewData.twitter
            }

        case 3:// Instagram
            if dependency.viewData.instagram.isEmpty {
                cell.textLabel?.text = "-"
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
                cell.textLabel?.text = dependency.viewData.instagram
            }

        case 4:// Youtube
            if dependency.viewData.youtube.isEmpty {
                cell.textLabel?.text = "-"
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
                cell.textLabel?.text = dependency.viewData.youtube
            }

        case 5:// Website
            if dependency.viewData.url.isEmpty {
                cell.textLabel?.text = "-"
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
                cell.textLabel?.text = dependency.viewData.url
            }

        default:
            break
        }

        return cell
    }

    func numberOfRowsInSection(section: Int) -> Int { 1 }

    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch indexPath.section {
        case 1:
            let urlString = cell?.textLabel?.text
            if let urlString = urlString, let url = URL(string: urlString) {
                dependency.router.presentWebsite(url: url)
            }

        case 2:
            let urlString = cell?.textLabel?.text
            if let urlString = urlString, let url = URL(string: urlString) {
                dependency.router.presentWebsite(url: url)
            }

        case 3:
            let urlString = cell?.textLabel?.text
            if let urlString = urlString, let url = URL(string: urlString) {
                dependency.router.presentWebsite(url: url)
            }

        case 4:
            let urlString = cell?.textLabel?.text
            if let urlString = urlString, let url = URL(string: urlString) {
                dependency.router.presentWebsite(url: url)
            }

        case 5:
            let urlString = cell?.textLabel?.text
            if let urlString = urlString, let url = URL(string: urlString) {
                dependency.router.presentWebsite(url: url)
            }

        default:
            break
        }
    }
}

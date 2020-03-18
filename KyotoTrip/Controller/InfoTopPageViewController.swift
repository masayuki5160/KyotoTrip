//
//  InfoTopPageViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import SafariServices
import RxSwift
import RxCocoa

class InfoTopPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let rssUrlStr = "https://www.city.kyoto.lg.jp/menu2/rss/rss.xml"
    var currentXMLItemName: String? = nil
    let xmlItemNameTitle = "title"
    let xmlItemNamelink = "link"
    let xmlItemNameDesctiption = "description"
    let xmlItemNamePublishDate = "pubDate"
    
    var kyotoCityInfoList: [KyotoCityInfoModel] = []
    var currentNewsModel: KyotoCityInfoModel? = nil

    private var vm = KyotoCityInfoViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupXMLParse()
    }
    
    private func setupTableView() {
        
        tableView.register(UINib(nibName: "InfoTopPageTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTopPageTableViewCell")

        vm.data.bind(to: tableView.rx.items(cellIdentifier: "InfoTopPageTableViewCell", cellType: InfoTopPageTableViewCell.self)) { row, element, cell in
            cell.title.text = element.title
            cell.publishDate.text = element.publishDate
        }.disposed(by: disposeBag)
        
    }
    
    private func setupXMLParse() {
        let parser = XMLParser(contentsOf: URL(string: rssUrlStr)!)
        parser?.delegate = self
        parser?.parse()
    }
    
}

extension InfoTopPageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = kyotoCityInfoList[indexPath.row]

        if let url = URL(string: data.link) {
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        }
    }

}

extension InfoTopPageViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
                
        currentXMLItemName = nil
        
        // itemから始まるツリーが来たらデータ処理開始
        if elementName == "item" {
            currentNewsModel = KyotoCityInfoModel()
        } else {
            currentXMLItemName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let text = string.trimmingCharacters(in: .whitespacesAndNewlines)

        // TODO: 煩雑なのでリファクタしたい(switch文以外でできないかな)
        // TODO: 全体的にVCから切り離しをしたい
        if text.count > 0 {
            switch currentXMLItemName {
                case xmlItemNameTitle:
                    self.currentNewsModel?.title = string
                case xmlItemNamelink:
                    self.currentNewsModel?.link = string
                case xmlItemNameDesctiption:
                    self.currentNewsModel?.description = string
                case xmlItemNamePublishDate:
                    self.currentNewsModel?.publishDate = string
                default:
                    break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // itemカテゴリのパースが完了したら配列に格納
        if let currentNewsModel = currentNewsModel, elementName == "item" {
            self.kyotoCityInfoList.append(currentNewsModel)
        }

        self.currentXMLItemName = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
    }
}

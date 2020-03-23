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
import Firebase

class InfoTopPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var vm = KyotoCityInfoViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NavigationBarTitleInfo".localized
        
        setupTableView()
        
        tlanslate(source: "りんご") { (tlanslatedText) in
            print("TEST RESULT: \(tlanslatedText)")
        }
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "InfoTopPageTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTopPageTableViewCell")

        vm.subscribableModelList.bind(to: tableView.rx.items(cellIdentifier: "InfoTopPageTableViewCell", cellType: InfoTopPageTableViewCell.self)) { row, element, cell in
            cell.title.text = element.title
            cell.publishDate.text = element.publishDate
        }.disposed(by: disposeBag)
        
    }
    
    // TODO: complitionにエラー情報をいれる
    private func tlanslate(source: String, completion: @escaping (String) -> Void) {
        let options = TranslatorOptions(sourceLanguage: .ja, targetLanguage: .en)
        let englishGermanTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
                
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        englishGermanTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }

            // Model downloaded successfully. Okay to start translating.
            englishGermanTranslator.translate(source) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return }

                completion(translatedText)
            }
        }
    }
        
}

// TODO: Rxを使うとUITableViewDelegateをなくせるか確認
extension InfoTopPageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = vm.modelList(index: indexPath.row)

        if let url = URL(string: data.link) {
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        }
    }

}

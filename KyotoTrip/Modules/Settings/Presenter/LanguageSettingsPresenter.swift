//
//  LanguageSettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/06/15.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxCocoa
import RxSwift

struct LanguageSettingsViewInput {
    let selectedCell: Driver<LanguageSettingsCellViewData>
}

protocol LanguageSettingsPresenterProtocol {
    var languagesDriver: Driver<[LanguageSettingsCellViewData]> { get }

    func bindView(input: LanguageSettingsViewInput)
    func saveSettings()
    func loadSettings()
}

class LanguageSettingsPresenter: LanguageSettingsPresenterProtocol {
    struct Dependency {
        let interactor: SettingsInteractorProtocol
    }
    var languagesDriver: Driver<[LanguageSettingsCellViewData]> {
        return languagesRelay.asDriver()
    }

    private var languagesRelay = BehaviorRelay<[LanguageSettingsCellViewData]>(
        value: LanguageSettings.allCases.map({ language -> LanguageSettingsCellViewData in
            LanguageSettingsCellViewData(language: language)
        })
    )
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    private var languageSetting: LanguageSettings = .japanese

    init(dependency: Dependency) {
        self.dependency = dependency
        fetchSettings()
    }

    func bindView(input: LanguageSettingsViewInput) {
        input.selectedCell.drive(onNext: { [weak self] cellViewData in
            let cells = LanguageSettings.allCases.map { language -> LanguageSettingsCellViewData in
                LanguageSettingsCellViewData(
                    language: language,
                    isSelect: language == cellViewData.language ? true : false
                )
            }

            self?.languagesRelay.accept(cells)
            self?.languageSetting = cellViewData.language
        }).disposed(by: disposeBag)
    }

    func saveSettings() {
        dependency.interactor.saveLanguageSetting(setting: languageSetting)
    }

    func loadSettings() {
        fetchSettings()
    }

    private func fetchSettings() {
        dependency.interactor.fetchLanguageSetting { [weak self] response in
            switch response {
            case .success(let setting):
                self?.languageSetting = setting
            case .failure(_):
                self?.languageSetting = .japanese
            }

            let cells = LanguageSettings.allCases.map { [weak self] language -> LanguageSettingsCellViewData in
                LanguageSettingsCellViewData(
                    language: language,
                    isSelect: language == self?.languageSetting ? true : false
                )
            }

            self?.languagesRelay.accept(cells)
        }
    }
}

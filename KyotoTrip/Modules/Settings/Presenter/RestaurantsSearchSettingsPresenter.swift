//
//  RestaurantsSearchSettingsPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import RxSwift
import RxCocoa

protocol RestaurantsSearchSettingsPresenterProtocol {
    var settingsRowsDriver: Driver<[RestaurantsSearchSettingsCellViewData]> { get }

    func bindView(input: RestauransSearchSettingsView)
    func saveSettings()
    func reloadSettings()
}

struct RestauransSearchSettingsView {
    let selectedCell: Driver<RestaurantsSearchSettingsCellViewData>
}

class RestaurantsSearchSettingsPresenter: RestaurantsSearchSettingsPresenterProtocol {
    struct Dependency {
        let interactor: SettingsInteractorProtocol
        let router: RestaurantsSearchSettingsRouterProtocol
    }

    var settingsRowsDriver: Driver<[RestaurantsSearchSettingsCellViewData]> {
        restaurantsSearchSettingsRows.asDriver()
    }

    private let dependency: Dependency
    private var restaurantsRequestParam = RestaurantsRequestParamEntity()
    private var restaurantsSearchSettingsTableData: [String] {
        RestaurantsSearchSetting.allCases.map { setting -> String in
            setting.toString()
        }
    }
    private let restaurantsSearchSettingsRows = BehaviorRelay<[RestaurantsSearchSettingsCellViewData]>(value: [])
    private let disposeBag = DisposeBag()

    init(dependency: Dependency) {
        self.dependency = dependency
        loadSettings()
    }

    func bindView(input: RestauransSearchSettingsView) {
        input.selectedCell.drive(onNext: { [weak self] viewData in
            guard let self = self else { return }

            if viewData.category == .searchRange {
                self.dependency.router.transitionToRestaurantsSearchRangeSettingView(
                    // swiftlint:disable force_cast
                    inject: self.dependency.interactor as! SettingsInteractor
                )
                return
            }

            self.restaurantsRequestParam =
                self.buildNewRequestSettings(from: viewData, current: self.restaurantsRequestParam)
            let searchSettingsRows = self.buildRestaurantsSettingRows(currentSettings: self.restaurantsRequestParam)
            self.restaurantsSearchSettingsRows.accept(searchSettingsRows)
        }
        ).disposed(by: disposeBag)
    }

    func saveSettings() {
        dependency.interactor.saveRestaurantsRequestParam(entity: restaurantsRequestParam)
    }

    func reloadSettings() {
        loadSettings()
    }
}

private extension RestaurantsSearchSettingsPresenter {
    private func buildRestaurantsSettingRows(currentSettings: RestaurantsRequestParamEntity) -> [RestaurantsSearchSettingsCellViewData] {
        RestaurantsSearchSetting.allCases.map { setting -> RestaurantsSearchSettingsCellViewData in
            var viewData = RestaurantsSearchSettingsCellViewData(
                title: setting.toString(),
                detail: "",
                isSelected: false,
                category: setting
            )

            switch setting {
            case .searchRange: viewData.detail = currentSettings.range.toString()
            case .englishSpeaker: viewData.isSelected = currentSettings.englishSpeakingStaff == .on ? true : false
            case .koreanSpeaker: viewData.isSelected = currentSettings.koreanSpeakingStaff == .on ? true : false
            case .chaineseSpeaker: viewData.isSelected = currentSettings.chineseSpeakingStaff == .on ? true : false
            case .vegetarian: viewData.isSelected = currentSettings.vegetarianMenuOptions == .on ? true : false
            case .creditCard: viewData.isSelected = currentSettings.card == .on ? true : false
            case .privateRoom: viewData.isSelected = currentSettings.privateRoom == .on ? true : false
            case .wifi: viewData.isSelected = currentSettings.wifi == .on ? true : false
            case .noSmoking: viewData.isSelected = currentSettings.noSmoking == .on ? true : false
            }

            return viewData
        }
    }

    private func loadSettings() {
        dependency.interactor.fetchRestaurantsRequestParam { [weak self] savedSettings in
            self?.restaurantsRequestParam = savedSettings

            let searchSettings = self?.buildRestaurantsSettingRows(currentSettings: savedSettings)
            restaurantsSearchSettingsRows.accept(searchSettings ?? [])
        }
    }

    private func buildNewRequestSettings(from viewData: RestaurantsSearchSettingsCellViewData, current settings: RestaurantsRequestParamEntity) -> RestaurantsRequestParamEntity {
        var newSetttings = settings

        switch viewData.category {
        case .englishSpeaker:
            newSetttings.englishSpeakingStaff = settings.englishSpeakingStaff.nextStatus()

        case .koreanSpeaker:
            newSetttings.koreanSpeakingStaff = settings.koreanSpeakingStaff.nextStatus()

        case .chaineseSpeaker:
            newSetttings.chineseSpeakingStaff = settings.chineseSpeakingStaff.nextStatus()

        case .vegetarian:
            newSetttings.vegetarianMenuOptions = settings.vegetarianMenuOptions.nextStatus()

        case .creditCard:
            newSetttings.card = settings.card.nextStatus()

        case .privateRoom:
            newSetttings.privateRoom = settings.privateRoom.nextStatus()

        case .wifi:
            newSetttings.wifi = settings.wifi.nextStatus()

        case .noSmoking:
            newSetttings.noSmoking = settings.noSmoking.nextStatus()

        default:
            break
        }

        return newSetttings
    }
}

//
//  CategoryPresenter.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/23.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import RxSwift
import RxCocoa
import Mapbox

protocol CategoryPresenterProtocol {
    /// Output from Presenter
    var cellsDriver: Driver<[CategoryCellViewData]> { get }
    /// Input to Presenter
    func bindCategoryView(input: CategoryViewInput)
}

struct CategoryViewInput {
    let culturalPropertyButton: Signal<Void>
    let busstopButton: Signal<Void>
    let restaurantButton: Signal<Void>
    let famousSitesButton: Signal<(Void)>
    let selectedCell: Signal<CategoryCellViewData>
}

class CategoryPresenter: CategoryPresenterProtocol {
    struct Dependency {
        let interactor: MapInteractorProtocol
        let router: CategoryRouterProtocol
    }

    var cellsDriver: Driver<[CategoryCellViewData]>

    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    private var categoryButtonsStatus = CategoryButtonsStatusViewData()

    init(dependency: Dependency) {
        self.dependency = dependency

        cellsDriver = dependency.interactor.visibleMarkers.map { markers -> [CategoryCellViewData] in
            markers.map { marker -> CategoryCellViewData in
                CategoryCellViewData(entity: marker)
            }
        }
    }

    func bindCategoryView(input: CategoryViewInput) {
        input.culturalPropertyButton.emit(onNext: { [weak self] in
            guard let self = self else { return }

            let nextStatus = self.categoryButtonsStatus.culturalProperty.next()
            self.categoryButtonsStatus.culturalProperty = nextStatus
            self.dependency.interactor.didSelectCulturalPropertyButton(nextStatus: nextStatus)
            }
        ).disposed(by: disposeBag)

        input.busstopButton.emit(onNext: { [weak self] in
            guard let self = self else { return }

            let nextStatus = self.categoryButtonsStatus.busstop.next()
            self.categoryButtonsStatus.busstop = nextStatus
            self.dependency.interactor.didSelectBusstopButton(nextStatus: nextStatus)
            }
        ).disposed(by: disposeBag)

        input.restaurantButton.emit(onNext: { [weak self] in
            guard let self = self else { return }

            let nextStatus = self.categoryButtonsStatus.restaurant.next()
            self.categoryButtonsStatus.restaurant = nextStatus
            self.dependency.interactor.didSelectRestaurantButton(nextStatus: nextStatus)
            }
        ).disposed(by: disposeBag)

        input.famousSitesButton.emit(onNext: { [weak self] in
            guard let self = self else { return }

            let nextStatus = self.categoryButtonsStatus.famousSites.next()
            self.categoryButtonsStatus.famousSites = nextStatus
            self.dependency.interactor.didSelectFamousSitesButton(nextStatus: nextStatus)
            }
        ).disposed(by: disposeBag)

        input.selectedCell.emit(onNext: { [weak self] cell in
            guard let self = self else { return }

            self.dependency.interactor.didSelectCategoryViewCell(viewData: cell.viewData)
            self.dependency.router.transitionToDetailViewController(inject: cell.viewData)
            }
        ).disposed(by: disposeBag)
    }
}

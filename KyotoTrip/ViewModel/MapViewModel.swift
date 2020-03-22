//
//  MapViewModel.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/21.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import Foundation
import Mapbox
import RxSwift
import RxCocoa

enum BusstopButtonStatus: Int {
    case hidden = 0
    case busstop
    case routeAndBusstop
}

class MapViewModel {
    private let mapView: MGLMapView
    let kyotoStationLat = 34.9857083
    let kyotoStationLong = 135.7560416
    let defaultZoomLv = 13.0
    
    private var busstopButtonStatus = BusstopButtonStatus.hidden
    private let busstopButtonStatusPublishRelay = PublishRelay<BusstopButtonStatus>()
    var busstopButtonStatusObservable: Observable<BusstopButtonStatus> {
        return busstopButtonStatusPublishRelay.asObservable()
    }
    
    let disposeBag = DisposeBag()
    
    init(mapView: MGLMapView, busstopButtonObservable: Observable<Void>, compassButtonObservable: Observable<Void>) {

        self.mapView = mapView
        setupMapView()
        
        busstopButtonObservable.subscribe { [weak self] (onNext) in

            let nextStatusRawValue = (self?.busstopButtonStatus.rawValue ?? 0) + 1
            self?.busstopButtonStatus = BusstopButtonStatus(rawValue: nextStatusRawValue) ?? BusstopButtonStatus.hidden
            
            self?.busstopButtonStatusPublishRelay.accept(self?.busstopButtonStatus ?? BusstopButtonStatus.hidden)
            
        }.disposed(by: disposeBag)
        
        compassButtonObservable.subscribe { (onNext) in
            // TODO: ボタンを押された回数に応じてTrackingModeを変えるのもあり
            // TODO: TrackingModeを変更する処理はVM側で実施するのがいい？VCで実施するのがいい？
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        }.disposed(by: disposeBag)
    }
    
    // TODO: MapViewのセットアップをここですべきかはあとで検討
    private func setupMapView() {
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: kyotoStationLat, longitude: kyotoStationLong), zoomLevel: defaultZoomLv, animated: false)

        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    }
}

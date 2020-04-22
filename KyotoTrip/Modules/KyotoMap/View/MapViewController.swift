//
//  MapViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import UIKit
import Mapbox
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    struct Dependency {
        let presenter: KyotoMapPresenterProtocol
    }
    
    @IBOutlet weak var mapView: KyotoMapView!
    @IBOutlet weak var busstopButton: UIButton!
    @IBOutlet weak var compassButton: UIButton!

    private let disposeBag = DisposeBag()
    private var dependency: Dependency!

    private var selectedAnnotation: MGLPointFeature!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindPresenter()
    }
    
    private func setupUI() {
        self.navigationItem.title = "NavigationBarTitleMap".localized
        busstopButton.layer.cornerRadius = 10.0
        compassButton.layer.cornerRadius = 10.0
        
        mapView.delegate = self
        mapView.setup()
        
        // TODO: Move to KyotoMapView.setup() or Presenter
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
    }
    
    private func bindPresenter() {
        dependency.presenter.subscribeButtonTapEvent(busstopButton: busstopButton.rx.tap.asObservable(), compassButton: compassButton.rx.tap.asObservable())

        dependency.presenter.busstopButtonStatusDriver.drive(onNext: { [weak self] (buttonStatus) in
            self?.updateBusstopLayer(buttonStatus)
        }).disposed(by: disposeBag)
        
        dependency.presenter.compassButtonStatusDriver.drive(onNext: { [weak self] (compassButtonStatus) in
            self?.updateMapCenterPosition(compassButtonStatus)
        }).disposed(by: disposeBag)
    }
    
    private func updateBusstopLayer(_ buttonStatus: BusstopButtonStatus) {
        switch buttonStatus {
        case BusstopButtonStatus.hidden:
            self.mapView.busstopLayer?.isVisible = false
            self.mapView.busRouteLayer?.isVisible = false
        case BusstopButtonStatus.busstop:
            self.mapView.busstopLayer?.isVisible = true
            self.mapView.busRouteLayer?.isVisible = false
        case BusstopButtonStatus.routeAndBusstop:
            self.mapView.busstopLayer?.isVisible = true
            self.mapView.busRouteLayer?.isVisible = true
        }
        
    }
    
    private func updateMapCenterPosition(_ compassButtonStatus: CompassButtonStatus) {
        let clLocationCoordinate2D = CLLocationCoordinate2DMake(
            KyotoMapView.kyotoStationLat,
            KyotoMapView.kyotoStationLong)
        
        switch compassButtonStatus {
        case .kyotoCity:
            self.mapView.setCenter(clLocationCoordinate2D, animated: true)
        case .currentLocation:
            self.mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        }
    }
    
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        // TODO: 他をタップしていたら削除するようにできているか確認
        if let selectedAnnotation = selectedAnnotation {
            mapView.removeAnnotation(selectedAnnotation)
        }

        if sender.state == .ended {
            let layerIdentifiers: Set = [KyotoMapView.busstopLayerName, KyotoMapView.busRouteLayerName]

            // Try matching the exact point first.
            let point = sender.location(in: sender.view!)
            for feature in mapView.visibleFeatures(at: point, styleLayerIdentifiers: layerIdentifiers) where feature is MGLPointFeature {
                guard let selectedFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                
                showCallout(feature: selectedFeature)
                return
            }
            
            let touchCoordinate = mapView.convert(point, toCoordinateFrom: sender.view!)
            let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
            
            // Otherwise, get all features within a rect the size of a touch (44x44).
            let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
            let possibleFeatures = mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: Set(layerIdentifiers)).filter { $0 is MGLPointFeature }

            // Select the closest feature to the touch center.
            let closestFeatures = possibleFeatures.sorted(by: {
                return CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: touchLocation) < CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: touchLocation)
            })
            if let feature = closestFeatures.first {
                guard let closestFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                showCallout(feature: closestFeature)
                return
            }
            
            // If no features were found, deselect the selected annotation, if any.
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        }
    }
    
    private func showCallout(feature: MGLPointFeature) {
        selectedAnnotation = MGLPointFeature()
        // TODO: Modelの作成, バスのデータがあれば、などの処理も追加
        let busstopName = feature.attribute(forKey: "P11_001") as! String

        selectedAnnotation.title = busstopName
        selectedAnnotation.subtitle = "This is subtitle"// TODO: Fix later
        selectedAnnotation.coordinate = feature.coordinate
        
        mapView.selectAnnotation(selectedAnnotation, animated: true, completionHandler: nil)
    }
}

extension MapViewController: DependencyInjectable {
    func inject(_ dependency: MapViewController.Dependency) {
        self.dependency = dependency
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        self.mapView.busstopLayer = style.layer(withIdentifier: KyotoMapView.busstopLayerName)
        self.mapView.busRouteLayer = style.layer(withIdentifier: KyotoMapView.busRouteLayerName)
        
        // Init busstop and bus route layers
        self.mapView.busstopLayer?.isVisible = false
        self.mapView.busRouteLayer?.isVisible = false
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        print("touched annotation view")
        // TODO: 詳細画面を作成する
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

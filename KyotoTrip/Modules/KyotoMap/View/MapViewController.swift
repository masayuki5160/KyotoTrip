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
import FloatingPanel

class MapViewController: UIViewController {
    
    struct Dependency {
        let presenter: KyotoMapPresenterProtocol
    }
    
    @IBOutlet weak var mapView: KyotoMapView!
    @IBOutlet weak var compassButton: UIButton!

    private let visibleFeaturesBehaviorRelay = BehaviorRelay<[MGLFeature]>(value: [])
    private let disposeBag = DisposeBag()
    private var dependency: Dependency!
    private var floatingPanelController: FloatingPanelController!
    private var tappedAnnotationCategory: VisibleFeatureCategory = .None

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindPresenter()
        setupCategorySemiModalView()
    }
}

private extension MapViewController {
    private func setupUI() {
        self.navigationItem.title = "NavigationBarTitleMap".localized
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "NavigationBarItemBack".localized, style: .plain, target: nil, action: nil)

        compassButton.layer.cornerRadius = 10.0
        
        mapView.delegate = self
        mapView.setup()
        
        // Add single tap gesture to mapView
        let singleTap = UITapGestureRecognizer()
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        singleTap.rx.event.asDriver().drive(onNext: { [weak self] (gesture) in
            self?.handleMapTap(sender: gesture)
        }).disposed(by: disposeBag)
    }
    
    private func bindPresenter() {
        dependency.presenter.bindMapView(input: MapViewInput(
            compassButton: compassButton.rx.tap.asDriver(),
            features: visibleFeaturesBehaviorRelay.asDriver())
        )

        dependency.presenter.visibleLayerDriver.drive(onNext: { [weak self] (visibleLayer) in
            guard let self = self else { return }

            self.updateBusstopLayer(visibleLayer.busstop)
            self.updateCulturalPropertyLayer(visibleLayer.culturalProperty)
            
            // FIXME: This is temporaly implementation. If there is a delegate method that is telling when the mapview layer visibility property was changed, use it.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.updateVisibleFeatures()
            }

        }).disposed(by: disposeBag)
        
        dependency.presenter.userPositionButtonStatusDriver.drive(onNext: { [weak self] (compassButtonStatus) in
            guard let self = self else { return }

            self.updateMapCenterPosition(compassButtonStatus)
        }).disposed(by: disposeBag)
        
        dependency.presenter.didSelectCellDriver.drive(onNext: { [weak self] feature in
            // FIXME: 初回起動時なイベントを購読する不具合回避
            if feature.title.isEmpty {
                print("TEST \(feature.title), \(feature.coordinate)")
                return
            }

            // Add annotation to mapview
            let annotation = MGLPointAnnotation()
            annotation.coordinate = feature.coordinate
            annotation.title = feature.title
            annotation.subtitle = "This is subtitle"
            self?.mapView.addAnnotation(annotation)

            // move camera position to the annotation position
            let camera = MGLMapCamera(lookingAtCenter: feature.coordinate, altitude: 4500, pitch: 0, heading: 0)
            self?.mapView.fly(to: camera, withDuration: 3, completionHandler: { [weak self] in
                self?.updateVisibleFeatures()
            })
        }).disposed(by: disposeBag)
    }
    
    private func setupCategorySemiModalView() {
        floatingPanelController = FloatingPanelController()
        let categoryViewController = AppDefaultDependencies().assembleCategoryModule(presenter: dependency.presenter)

        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.set(contentViewController: categoryViewController)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    private func updateBusstopLayer(_ visibleStatus: VisibleLayer.Status) {
        switch visibleStatus {
        case .hidden:
            self.mapView.busstopLayer?.isVisible = false
        case .visible:
            self.mapView.busstopLayer?.isVisible = true
        }
    }
    
    private func updateCulturalPropertyLayer(_ visibleStatus: VisibleLayer.Status) {
        switch visibleStatus {
        case .hidden:
            self.mapView.culturalPropertyLayer?.isVisible = false
        case .visible:
            self.mapView.culturalPropertyLayer?.isVisible = true
        }
    }
    
    private func updateVisibleFeatures() {
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        var layers: Set<String> = []
        
        if let busstopLayer = mapView.busstopLayer, busstopLayer.isVisible {
            layers.insert(BusstopFeature.layerId)
        }
        if let culturalPropertyLayer = mapView.culturalPropertyLayer, culturalPropertyLayer.isVisible {
            layers.insert(CulturalPropertyFeature.layerId)
        }
                
        let features = self.mapView.visibleFeatures(in: rect, styleLayerIdentifiers: layers)
        visibleFeaturesBehaviorRelay.accept(features)
    }
    
    private func updateMapCenterPosition(_ compassButtonStatus: UserPosition) {
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
    
    private func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Try matching the exact point first.
            let point = sender.location(in: sender.view!)
            for feature in mapView.visibleFeatures(at: point, styleLayerIdentifiers: KyotoMapPresenter.layerIdentifiers) where feature is MGLPointFeature {
                guard let selectedFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                
                showCallout(feature: selectedFeature)
                return
            }

            // Select the closest feature to the touch center.
            let closestFeatures = searchClosestFeature(sender)
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
    
    private func searchClosestFeature(_ sender: UITapGestureRecognizer) -> [MGLFeature] {
        let point = sender.location(in: sender.view!)
        let touchCoordinate = mapView.convert(point, toCoordinateFrom: sender.view!)
        let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        
        // Get all features within a rect the size of a touch (44x44).
        let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
        let possibleFeatures = mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: Set(KyotoMapPresenter.layerIdentifiers)).filter { $0 is MGLPointFeature }
        // Select the closest feature to the touch center.
        let closestFeatures = dependency.presenter.sorteFeatures(features: possibleFeatures, center: touchLocation)

        return closestFeatures
    }
    
    private func showCallout(feature: MGLPointFeature) {
        let visibleFeature = dependency.presenter.convertMGLFeatureToVisibleFeature(source: feature)

        let selectedAnnotation = MGLPointFeature()
        selectedAnnotation.title = visibleFeature.title
        selectedAnnotation.subtitle = visibleFeature.subtitle
        selectedAnnotation.coordinate = visibleFeature.coordinate
        
        tappedAnnotationCategory = visibleFeature.type
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
        let kyotoMapView = mapView as! KyotoMapView
        kyotoMapView.busstopLayer = style.layer(withIdentifier: BusstopFeature.layerId)
        kyotoMapView.busRouteLayer = style.layer(withIdentifier: BusRouteFeature.layerId)
        kyotoMapView.culturalPropertyLayer = style.layer(withIdentifier: CulturalPropertyFeature.layerId)
        
        // Init visible layers
        kyotoMapView.busstopLayer?.isVisible = false
        kyotoMapView.busRouteLayer?.isVisible = false
        kyotoMapView.culturalPropertyLayer?.isVisible = false
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }

    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        mapView.removeAnnotations([annotation])
        tappedAnnotationCategory = .None
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let viewController: UIViewController

        switch tappedAnnotationCategory {
        case .Busstop:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule()
        case .CulturalProperty:
            viewController = AppDefaultDependencies().assembleCulturalPropertyDetailModule()
        default:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule()
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

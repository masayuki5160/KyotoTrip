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

    private let visibleFeatures = BehaviorRelay<[MGLFeature]>(value: [])
    private let disposeBag = DisposeBag()
    private var dependency: Dependency!
    private var floatingPanelController: FloatingPanelController!
    private var currentVisibleRestaurantAnnotations: [MGLPointAnnotation] = []
    private var currentVisibleLayer: VisibleFeatureCategory = .None
    private var visibleFeatureForTappedCalloutView: VisibleFeatureProtocol? = nil

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
            features: visibleFeatures.asDriver())
        )

        Driver.combineLatest(
            dependency.presenter.visibleLayerDriver,
            dependency.presenter.visibleFeatureRestaurantEntityDriver
        ){($0, $1)}.map { (visibleLayer, features) -> (VisibleLayerEntity, [RestaurantPointAnnotation]) in
                var annotations: [RestaurantPointAnnotation] = []
                for feature in features {
                    let annotation = self.dependency.presenter.createRestaurantAnnotation(
                        entity: feature as! RestaurantFeatureEntity
                    )
                    annotations.append(annotation)
                }
                return (visibleLayer, annotations)
        }.drive(onNext: { [weak self] (visibleLayer, annotations) in
            guard let self = self else { return }
            
            self.currentVisibleLayer = visibleLayer.currentVisibleLayer()
            
            self.updateBusstopLayer(visibleLayer.busstop)
            self.updateCulturalPropertyLayer(visibleLayer.culturalProperty)
            
            // FIXME: This is temporaly implementation. If there is a delegate method that is telling when the mapview layer visibility property was changed, use it.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.updateVisibleFeatures()
            }
            
            self.updateRestaurantLayer(visibleStatus:visibleLayer.restaurant, annotations: annotations)
        }).disposed(by: disposeBag)
        
        dependency.presenter.userPositionButtonStatusDriver.drive(onNext: { [weak self] (compassButtonStatus) in
            guard let self = self else { return }

            self.updateMapCenterPosition(compassButtonStatus)
        }).disposed(by: disposeBag)
        
        dependency.presenter.didSelectCellDriver.drive(onNext: { [weak self] feature in
            // FIXME: 初回起動時なイベントを購読する不具合回避
            if feature.title.isEmpty {
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
        let categoryViewController = AppDefaultDependencies().assembleCategoryModule(presenter: dependency.presenter)

        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.set(contentViewController: categoryViewController)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    private func updateBusstopLayer(_ visibleStatus: VisibleLayerEntity.Status) {
        switch visibleStatus {
        case .hidden:
            self.mapView.busstopLayer?.isVisible = false
        case .visible:
            self.mapView.busstopLayer?.isVisible = true
        }
    }
    
    private func updateCulturalPropertyLayer(_ visibleStatus: VisibleLayerEntity.Status) {
        switch visibleStatus {
        case .hidden:
            self.mapView.culturalPropertyLayer?.isVisible = false
        case .visible:
            self.mapView.culturalPropertyLayer?.isVisible = true
        }
    }

    // FIXME: 2回同時にコールされる不具合がある
    private func updateRestaurantLayer(visibleStatus: VisibleLayerEntity.Status, annotations: [MGLPointAnnotation]) {
        // Remove current annotations, and add annotations again
        mapView.removeAnnotations(currentVisibleRestaurantAnnotations)
        currentVisibleRestaurantAnnotations = []

        switch visibleStatus {
        case .hidden:
            print("Restaurant layer is hidden")
        case .visible:
            print("Restaurant layer is visible")
            currentVisibleRestaurantAnnotations = annotations
            mapView.addAnnotations(annotations)
        }
    }
    
    private func updateVisibleFeatures() {
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        var layers: Set<String> = []
        
        if let busstopLayer = mapView.busstopLayer, busstopLayer.isVisible {
            layers.insert(BusstopFeatureEntity.layerId)
        }
        if let culturalPropertyLayer = mapView.culturalPropertyLayer, culturalPropertyLayer.isVisible {
            layers.insert(CulturalPropertyFeatureEntity.layerId)
        }
                
        let features = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: layers)
        visibleFeatures.accept(features)
    }
    
    private func updateMapCenterPosition(_ compassButtonStatus: UserPosition) {
        let clLocationCoordinate2D = CLLocationCoordinate2DMake(
            KyotoMapView.kyotoStationLat,
            KyotoMapView.kyotoStationLong)
        
        switch compassButtonStatus {
        case .kyotoCity:
            mapView.setCenter(clLocationCoordinate2D, animated: true)
        case .currentLocation:
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
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
        visibleFeatureForTappedCalloutView = visibleFeature

        let selectedAnnotation = MGLPointFeature()
        selectedAnnotation.title = visibleFeature.title
        selectedAnnotation.subtitle = visibleFeature.subtitle
        selectedAnnotation.coordinate = visibleFeature.coordinate
        
        mapView.selectAnnotation(selectedAnnotation, animated: true, completionHandler: nil)
    }
}

extension MapViewController: DependencyInjectable {
    func inject(_ dependency: MapViewController.Dependency) {
        self.dependency = dependency
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let kyotoMapView = mapView as! KyotoMapView
        kyotoMapView.busstopLayer = style.layer(withIdentifier: BusstopFeatureEntity.layerId)
        kyotoMapView.busRouteLayer = style.layer(withIdentifier: BusRouteFeatureEntity.layerId)
        kyotoMapView.culturalPropertyLayer = style.layer(withIdentifier: CulturalPropertyFeatureEntity.layerId)
        
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
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        var viewController: DetailViewProtocol

        switch currentVisibleLayer {
        case .Busstop:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule() as! BusstopDetailViewController
            viewController.visibleFeatureEntity = visibleFeatureForTappedCalloutView
        case .CulturalProperty:
            viewController = AppDefaultDependencies().assembleCulturalPropertyDetailModule() as! CulturalPropertyDetailViewController
            viewController.visibleFeatureEntity = visibleFeatureForTappedCalloutView
        case .Restaurant:
            viewController = AppDefaultDependencies().assembleRestaurantDetailModule() as! RestaurantDetailViewController
            let restaurantAnnotation = annotation as! RestaurantPointAnnotation
            viewController.visibleFeatureEntity = restaurantAnnotation.entity
        default:
            viewController = AppDefaultDependencies().assembleBusstopDetailModule() as! BusstopDetailViewController
            viewController.visibleFeatureEntity = visibleFeatureForTappedCalloutView
        }
        self.navigationController?.pushViewController(viewController as! UIViewController, animated: true)
    }
}

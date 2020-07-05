//
//  MapViewController.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/03/13.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//

import FloatingPanel
import RxCocoa
import RxSwift
import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

class MapViewController: UIViewController, TransitionerProtocol {
    struct Dependency {
        let presenter: MapPresenterProtocol
        let categoryView: UIViewController
        let mglFeatureMediator: MGLFeatureMediatorProtocol
    }

    @IBOutlet private weak var mapView: MapView!
    @IBOutlet private weak var compassButton: UIButton!

    // swiftlint:disable implicitly_unwrapped_optional
    private var dependency: Dependency!
    // swiftlint:disable implicitly_unwrapped_optional
    private var floatingPanelController: FloatingPanelController!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindPresenter()
        setupCategorySemiModalView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.mglFeatureMediator.loadSettings()
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
        // swiftlint:disable force_unwrapping
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        singleTap.rx.event.asDriver().drive(onNext: { [weak self] gesture in
            self?.handleMapTap(sender: gesture)
            }
        ).disposed(by: disposeBag)
    }

    private func bindPresenter() {
        /// Bind to Presenter

        dependency.presenter.bindMapView(
            input: MapViewInput(
                compassButtonTapEvent: compassButton.rx.tap.asDriver()
            )
        )

        /// Subscribe from Presenter

        dependency.presenter.categoryButtonsStatusDriver.drive(onNext: { [weak self] buttonsStatus in
            guard let self = self else { return }

            /// Deselect markers
            self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
            /// Update markers
            self.updateBusstopLayer(status: buttonsStatus.busstop)
            self.updateCulturalPropertyLayer(status: buttonsStatus.culturalProperty)
            self.updateFamousSitesLayer(status: buttonsStatus.famousSites)
            }
        ).disposed(by: disposeBag)

        dependency.presenter.restaurantMarkersDriver.drive(onNext: { [weak self] annotations in
            guard let self = self else { return }
            self.updateRestaurantMarkers(annotations: annotations)
            }
        ).disposed(by: disposeBag)

        dependency.presenter.mapCenterPositionDriver.drive(onNext: { [weak self] compassButtonStatus in
            guard let self = self else { return }
            self.updateMapCenterPosition(compassButtonStatus)
            }
        ).disposed(by: disposeBag)

        dependency.presenter.selectedCategoryViewCellSignal.emit(onNext: {  [weak self] selectedCell in
            guard let self = self else { return }

            /// Move camera position to the annotation position
            let camera = MGLMapCamera(lookingAtCenter: selectedCell.coordinate, altitude: 4500, pitch: 0, heading: 0)
            self.mapView.fly(to: camera, withDuration: 3, completionHandler: nil)
            /// Add annotation to mapView
            let selectedAnnotation = CustomMGLPointAnnotation(viewData: selectedCell)
            self.mapView.selectAnnotation(selectedAnnotation, animated: true, completionHandler: nil)
            }
        ).disposed(by: disposeBag)
    }

    private func setupCategorySemiModalView() {
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.set(contentViewController: dependency.categoryView)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }

    private func updateRestaurantMarkers(annotations: [MGLPointAnnotation]) {
        if annotations.count > 0 {
            mapView.addAnnotations(annotations)
        } else {
            if let selectedAnnotation = mapView.selectedAnnotations.first {
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
            }
            if let visibleAnnotations = mapView.visibleAnnotations {
                mapView.removeAnnotations(visibleAnnotations)
            }
        }
    }

    private func updateBusstopLayer(status: CategoryButtonStatus) {
        if status == .visible {
            self.mapView.busstopLayer?.isVisible = true
        } else {
            self.mapView.busstopLayer?.isVisible = false
        }
    }

    private func updateCulturalPropertyLayer(status: CategoryButtonStatus) {
        if status == .visible {
            self.mapView.culturalPropertyLayer?.isVisible = true
        } else {
            self.mapView.culturalPropertyLayer?.isVisible = false
        }
    }

    private func updateFamousSitesLayer(status: CategoryButtonStatus) {
        if status == .visible {
            self.mapView.famousSitesLayer?.isVisible = true
        } else {
            self.mapView.famousSitesLayer?.isVisible = false
        }
    }

    private func updateMapCenterPosition(_ compassButtonStatus: MapCenterPosition) {
        let clLocationCoordinate2D = CLLocationCoordinate2DMake(
            MapView.kyotoStationLat,
            MapView.kyotoStationLong
        )

        switch compassButtonStatus {
        case .kyotoCity:
            mapView.setCenter(clLocationCoordinate2D, animated: true)

        case .userLocation:
            mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        }
    }

    private func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Try matching the exact point first.
            let point = sender.location(in: sender.view!)
            for feature in mapView.visibleFeatures(at: point, styleLayerIdentifiers: MapPresenter.layerIdentifiers) where feature is MGLPointFeature {
                guard let selectedFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                showCallout(from: selectedFeature)
                return
            }

            // Select the closest feature to the touch center.
            let closestFeatures = searchClosestFeatures(sender)
            if let feature = closestFeatures.first {
                guard let closestFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                showCallout(from: closestFeature)
                return
            }

            // If no features were found, deselect the selected annotation
            mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        }
    }

    private func searchClosestFeatures(_ sender: UITapGestureRecognizer) -> [MGLFeature] {
        let point = sender.location(in: sender.view!)
        let touchCoordinate = mapView.convert(point, toCoordinateFrom: sender.view!)
        let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)

        // Get all features within a rect the size of a touch (44x44).
        let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
        let possibleFeatures = mapView.visibleFeatures(
            in: touchRect,
            styleLayerIdentifiers: Set(MapPresenter.layerIdentifiers)
        ).filter { $0 is MGLPointFeature }

        // Select the closest feature to the touch center.
        let closestFeatures = dependency.mglFeatureMediator
            .sorteMGLFeatures(features: possibleFeatures, center: touchLocation)

        return closestFeatures
    }

    private func showCallout(from mglFeature: MGLPointFeature) {
        let selectedAnnotation = dependency.mglFeatureMediator.convertMGLFeatureToAnnotation(source: mglFeature)
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
        guard let kyotoMapView = mapView as? MapView else { return }

        kyotoMapView.busstopLayer = style.layer(withIdentifier: BusstopMarkerEntity.layerId)
        kyotoMapView.busRouteLayer = style.layer(withIdentifier: BusRouteMarkerEntity.layerId)
        kyotoMapView.culturalPropertyLayer = style.layer(withIdentifier: CulturalPropertyMarkerEntity.layerId)
        kyotoMapView.famousSitesLayer = style.layer(withIdentifier: FamousSitesMarkerEntity.layerId)

        // Init visible layers
        kyotoMapView.busstopLayer?.isVisible = false
        kyotoMapView.busRouteLayer?.isVisible = false
        kyotoMapView.culturalPropertyLayer?.isVisible = false
        kyotoMapView.famousSitesLayer?.isVisible = false
    }

    func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {
        if fullyRendered {
            let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            let layers: Set<String> = [
                BusstopMarkerEntity.layerId,
                CulturalPropertyMarkerEntity.layerId,
                FamousSitesMarkerEntity.layerId
            ]
            /// Get features from Style Layers which is defined in Mapbox Studio
            let features = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: layers)
            self.dependency.mglFeatureMediator.updateVisibleMGLFeatures(mglFeatures: features)
        }
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }

    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
    }

    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        guard let annotation = annotation as? CustomMGLPointAnnotation else { return }
        dependency.presenter.tapOnCallout(viewData: annotation.viewData!)
    }

    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        dependency.presenter.updateViewpoint(centerCoordinate: mapView.centerCoordinate)
    }

    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let image = UIImage(named: "icons8-walking-50")
        let button = UIButton(type: .infoLight)
        button.setImage(image, for: .normal)
        return button
    }

    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        mapView.deselectAnnotation(annotation, animated: false)

        guard let userLocation = mapView.userLocation,
            let location = userLocation.location,
            let annotation = annotation as? CustomMGLPointAnnotation else { return }

        // Define two waypoints to travel between
        let origin = Waypoint(coordinate: location.coordinate, name: "CurrentLocation")
        let destination = Waypoint(coordinate: annotation.coordinate, name: annotation.title)

        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .walking)
        let navigationOptions = NavigationOptions()
        if #available(iOS 13, *), UITraitCollection.current.userInterfaceStyle == .dark {
            navigationOptions.styles = [CustomNavigationNightStyle()]
        } else {
            navigationOptions.styles = [CustomNavigationDayStyle()]
        }

        // TODO: Add loading indicator
        // Request a route
        Directions.shared.calculate(routeOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }

                // Pass the generated route to the the NavigationViewController
                let viewController = NavigationViewController(for: route, routeOptions: routeOptions, navigationOptions: navigationOptions)
                viewController.modalPresentationStyle = .fullScreen
                strongSelf.present(viewController, animated: true, completion: nil)
            }
        }
    }
}

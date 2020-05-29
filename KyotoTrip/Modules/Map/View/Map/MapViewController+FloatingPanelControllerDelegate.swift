//
//  MapViewController+FloatingPanelControllerDelegate.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/26.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import FloatingPanel

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }
}

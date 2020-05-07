//
//  CustomFloatingPanelLayout.swift
//  KyotoTrip
//
//  Created by TANAKA MASAYUKI on 2020/05/07.
//  Copyright © 2020 TANAKA MASAYUKI. All rights reserved.
//
import FloatingPanel

class CustomFloatingPanelLayout: FloatingPanelLayout {

    var initialPosition: FloatingPanelPosition { return .tip }
    var topInteractionBuffer: CGFloat { return 0.0 }
    var bottomInteractionBuffer: CGFloat { return 0.0 }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 56.0
        case .half:
            return 262.0
        case .tip:
            return 100.0
        case .hidden:
            return 0.0
        }
    }

    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}

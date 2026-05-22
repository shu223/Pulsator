//
//  View+Pulsator.swift
//  Pulsator
//
//  Created by Shuichi Tsutsumi on 2026/05/22.
//  Copyright © 2026 Shuichi Tsutsumi. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
public extension View {

    /// Adds a `Pulsator` pulse animation behind this view.
    ///
    /// The pulse is added as a background, so it sits behind the view, stays
    /// centered on it, and expands outward beyond the view's bounds without
    /// being clipped — the same effect as adding `Pulsator` as a sublayer in
    /// UIKit. The view keeps its own size; only the pulse overflows.
    ///
    ///     Image(systemName: "bell.fill")
    ///         .pulsator()
    ///
    /// Defaults mirror `PulsatorView.init`.
    ///
    /// - Parameters:
    ///   - numPulse: The number of pulses shown at the same time.
    ///   - radius: The radius of a pulse.
    ///   - animationDuration: The animation duration in seconds.
    ///   - color: The color (including opacity) of a pulse.
    ///   - isPulsating: Whether the animation is running. Set to `false` to stop it.
    func pulsator(
        numPulse: Int = PulsatorView.defaultNumPulse,
        radius: CGFloat = PulsatorView.defaultRadius,
        animationDuration: TimeInterval = PulsatorView.defaultAnimationDuration,
        color: SwiftUI.Color = PulsatorView.defaultColor,
        isPulsating: Bool = true
    ) -> some View {
        background(alignment: .center) {
            PulsatorView(
                numPulse: numPulse,
                radius: radius,
                animationDuration: animationDuration,
                color: color,
                isPulsating: isPulsating
            )
        }
    }
}

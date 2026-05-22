//
//  PulsatorView.swift
//  Pulsator
//
//  Created by Shuichi Tsutsumi on 2026/05/22.
//  Copyright © 2026 Shuichi Tsutsumi. All rights reserved.
//

import SwiftUI
import QuartzCore

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

// MARK: - PulsatorView

/// A SwiftUI view that displays the `Pulsator` pulse animation.
///
/// `Pulsator` is a `CAReplicatorLayer` subclass, so it cannot be placed in a
/// SwiftUI hierarchy directly. This wrapper hosts it inside a backing view and
/// keeps the pulse centered as the layout changes.
///
/// The pulse expands outward from the center beyond the view's own bounds, so
/// give this view a frame large enough for the pulse (roughly `radius * 2`) and
/// avoid clipping it.
@available(iOS 14.0, macOS 11.0, *)
public struct PulsatorView {

    /// The number of pulses shown at the same time.
    public var numPulse: Int

    /// The radius of a pulse.
    public var radius: CGFloat

    /// The animation duration in seconds.
    public var animationDuration: TimeInterval

    /// The color (including opacity) of a pulse.
    public var color: SwiftUI.Color

    /// Whether the animation is running. Set to `false` to stop it.
    public var isPulsating: Bool

    /// Default parameter values, shared by `PulsatorView.init` and the
    /// `pulsator(...)` view modifier so the two stay in sync.
    public static let defaultNumPulse = 1
    public static let defaultRadius: CGFloat = 60
    public static let defaultAnimationDuration: TimeInterval = 3
    public static let defaultColor = SwiftUI.Color(red: 0, green: 0.455, blue: 0.756).opacity(0.45)

    public init(
        numPulse: Int = PulsatorView.defaultNumPulse,
        radius: CGFloat = PulsatorView.defaultRadius,
        animationDuration: TimeInterval = PulsatorView.defaultAnimationDuration,
        color: SwiftUI.Color = PulsatorView.defaultColor,
        isPulsating: Bool = true
    ) {
        self.numPulse = numPulse
        self.radius = radius
        self.animationDuration = animationDuration
        self.color = color
        self.isPulsating = isPulsating
    }
}

// MARK: - Shared configuration

/// Applies the wrapper's parameters to the underlying `Pulsator`.
///
/// Shared by the iOS and macOS hosting views so the mapping logic lives in one
/// place.
@available(iOS 14.0, macOS 11.0, *)
private func configure(
    _ pulsator: Pulsator,
    numPulse: Int,
    radius: CGFloat,
    animationDuration: TimeInterval,
    cgColor: CGColor,
    isPulsating: Bool
) {
    pulsator.numPulse = numPulse
    pulsator.radius = radius
    pulsator.animationDuration = animationDuration
    pulsator.backgroundColor = cgColor

    if isPulsating {
        if !pulsator.isPulsating {
            pulsator.start()
        }
    } else if pulsator.isPulsating {
        pulsator.stop()
    }
}

// MARK: - iOS

#if os(iOS)
@available(iOS 14.0, *)
extension PulsatorView: UIViewRepresentable {

    // Returns `UIView` (not `PulsatorHostingView`) so the hosting view can stay
    // internal: a `public` representable method cannot expose an internal type.
    public func makeUIView(context: Context) -> UIView {
        PulsatorHostingView()
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // `makeUIView` always returns a `PulsatorHostingView`.
        let hostingView = uiView as! PulsatorHostingView
        hostingView.isPulsating = isPulsating
        configure(
            hostingView.pulsator,
            numPulse: numPulse,
            radius: radius,
            animationDuration: animationDuration,
            cgColor: UIColor(color).cgColor,
            isPulsating: isPulsating
        )
    }
}

/// A backing `UIView` that hosts a `Pulsator` and keeps it centered.
@available(iOS 14.0, *)
final class PulsatorHostingView: UIView {

    let pulsator = Pulsator()
    fileprivate var isPulsating = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(pulsator)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        pulsator.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        // Core Animation removes a layer's animations while it is off-screen
        // (e.g. while another screen is pushed over this one in a
        // NavigationStack). `updateUIView` is not guaranteed to run on return,
        // so resume here when the view is re-attached to a window.
        if window != nil, isPulsating, !pulsator.isPulsating {
            pulsator.start()
        }
    }
}
#endif

// MARK: - macOS

#if os(macOS)
@available(macOS 11.0, *)
extension PulsatorView: NSViewRepresentable {

    // Returns `NSView` (not `PulsatorHostingView`) so the hosting view can stay
    // internal: a `public` representable method cannot expose an internal type.
    public func makeNSView(context: Context) -> NSView {
        PulsatorHostingView()
    }

    public func updateNSView(_ nsView: NSView, context: Context) {
        // `makeNSView` always returns a `PulsatorHostingView`.
        let hostingView = nsView as! PulsatorHostingView
        hostingView.isPulsating = isPulsating
        configure(
            hostingView.pulsator,
            numPulse: numPulse,
            radius: radius,
            animationDuration: animationDuration,
            cgColor: NSColor(color).cgColor,
            isPulsating: isPulsating
        )
    }
}

@available(macOS 11.0, *)
final class PulsatorHostingView: NSView {

    let pulsator = Pulsator()
    fileprivate var isPulsating = true

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.addSublayer(pulsator)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()
        pulsator.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        // Core Animation removes a layer's animations while it is off-screen.
        // `updateNSView` is not guaranteed to run on return, so resume here
        // when the view is re-attached to a window.
        if window != nil, isPulsating, !pulsator.isPulsating {
            pulsator.start()
        }
    }
}
#endif


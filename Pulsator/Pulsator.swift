//
//  Pulsator.swift
//  Pulsator
//
//  Created by Shuichi Tsutsumi on 4/9/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//  Objective-C version: https://github.com/shu223/PulsingHalo

#if os(iOS)
import UIKit
public typealias Color = UIColor
    
internal let screenScale = UIScreen.main.scale
internal let applicationWillBecomeActiveNotfication = UIApplication.willEnterForegroundNotification
internal let applicationDidResignActiveNotification = UIApplication.didEnterBackgroundNotification
#elseif os(macOS)
import Cocoa
public typealias Color = NSColor
    
internal let screenScale = NSScreen.main?.backingScaleFactor ?? 0.0
internal let applicationWillBecomeActiveNotfication = NSApplication.willBecomeActiveNotification
internal let applicationDidResignActiveNotification = NSApplication.didResignActiveNotification
#endif
import QuartzCore

internal let kPulsatorAnimationKey = "pulsator"

open class Pulsator: CAReplicatorLayer, CAAnimationDelegate {

    fileprivate let pulse = CALayer()
    fileprivate var animationGroup: CAAnimationGroup!
    fileprivate var alpha: CGFloat = 0.45

    override open var backgroundColor: CGColor? {
        didSet {
            pulse.backgroundColor = backgroundColor
            guard let backgroundColor = backgroundColor else {return}
            let oldAlpha = alpha
            alpha = backgroundColor.alpha
            if alpha != oldAlpha {
                recreate()
            }
        }
    }
    
    override open var repeatCount: Float {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.repeatCount = repeatCount
            }
        }
    }
    
    // MARK: - Public Properties

    /// The number of pulse.
    @objc open var numPulse: Int = 1 {
        didSet {
            if numPulse < 1 {
                numPulse = 1
            }
            instanceCount = numPulse
            updateInstanceDelay()
        }
    }
    
    ///	The radius of pulse.
    @objc open var radius: CGFloat = 60 {
        didSet {
            updatePulse()
        }
    }
    
    /// The animation duration in seconds.
   @objc  open var animationDuration: TimeInterval = 3 {
        didSet {
            updateInstanceDelay()
        }
    }
    
    /// If this property is `true`, the instanse will be automatically removed
    /// from the superview, when it finishes the animation.
    @objc open var autoRemove = false
    
    /// fromValue for radius
    /// It must be smaller than 1.0
    @objc open var fromValueForRadius: Float = 0.0 {
        didSet {
            if fromValueForRadius >= 1.0 {
                fromValueForRadius = 0.0
            }
            recreate()
        }
    }
    
    /// The value of this property should be ranging from @c 0 to @c 1 (exclusive).
    @objc open var keyTimeForHalfOpacity: Float = 0.2 {
        didSet {
            recreate()
        }
    }
    
    /// The animation interval in seconds.
    @objc open var pulseInterval: TimeInterval = 0
    
    /// A function describing a timing curve of the animation.
    @objc open var timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: .default) {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.timingFunction = timingFunction
            }
        }
    }
    
    /// The value of this property showed a pulse is started
    @objc open var isPulsating: Bool {
        guard let keys = pulse.animationKeys() else {return false}
        return keys.count > 0
    }
    
    /// private properties for resuming
    fileprivate weak var prevSuperlayer: CALayer?
    fileprivate var prevLayerIndex: Int?
    
    // MARK: - Initializer

    override public init() {
        super.init()
        
        setupPulse()
        
        instanceDelay = 1
        repeatCount = MAXFLOAT
        backgroundColor = Color(red: 0, green: 0.455, blue: 0.756, alpha: 0.45).cgColor
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: applicationDidResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resume),
                                               name: applicationWillBecomeActiveNotfication,
                                               object: nil)
    }
    
    override public init(layer: Any) {
        super.init(layer: layer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupPulse() {
        pulse.contentsScale = screenScale
        pulse.opacity = 0
        addSublayer(pulse)
        updatePulse()
    }
    
    fileprivate func setupAnimationGroup() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = fromValueForRadius
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = animationDuration
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [alpha, alpha * 0.5, 0.0]
        opacityAnimation.keyTimes = [0.0, NSNumber(value: keyTimeForHalfOpacity), 1.0]
        
        animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = animationDuration + pulseInterval
        animationGroup.repeatCount = repeatCount
        if let timingFunction = timingFunction {
            animationGroup.timingFunction = timingFunction
        }
        animationGroup.delegate = self
    }
    
    fileprivate func updatePulse() {
        let diameter: CGFloat = radius * 2
        pulse.bounds = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: diameter, height: diameter))
        pulse.cornerRadius = radius
        pulse.backgroundColor = backgroundColor
    }
    
    fileprivate func updateInstanceDelay() {
        guard numPulse >= 1 else { fatalError() }
        instanceDelay = (animationDuration + pulseInterval) / Double(numPulse)
    }
    
    fileprivate func recreate() {
        guard animationGroup != nil else { return }        // Not need to be recreated.
        stop()
        let when = DispatchTime.now() + Double(Int64(0.2 * double_t(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: when) { () -> Void in
            self.start()
        }
    }
    
    // MARK: - Internal Methods
    
    @objc internal func save() {
        prevSuperlayer = superlayer
        prevLayerIndex = prevSuperlayer?.sublayers?.index(where: {$0 === self})
    }

    @objc internal func resume() {
        if let prevSuperlayer = prevSuperlayer, let prevLayerIndex = prevLayerIndex {
            prevSuperlayer.insertSublayer(self, at: UInt32(prevLayerIndex))
        }
        if pulse.superlayer == nil {
            addSublayer(pulse)
        }
        let isAnimating = pulse.animation(forKey: kPulsatorAnimationKey) != nil
        // if the animationGroup is not nil, it means the animation was not stopped
        if let animationGroup = animationGroup, !isAnimating {
            pulse.add(animationGroup, forKey: kPulsatorAnimationKey)
        }
    }
    
    // MARK: - Public Methods
    
    /// Start the animation.
    @objc open func start() {
        setupPulse()
        setupAnimationGroup()
        pulse.add(animationGroup, forKey: kPulsatorAnimationKey)
    }
    
    /// Stop the animation.
    @objc open func stop() {
        pulse.removeAllAnimations()
        animationGroup = nil
    }
    
    
    // MARK: - Delegate methods for CAAnimation
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let keys = pulse.animationKeys(), keys.count > 0 {
            pulse.removeAllAnimations()
        }
        pulse.removeFromSuperlayer()
        
        if autoRemove {
            removeFromSuperlayer()
        }
    }
}

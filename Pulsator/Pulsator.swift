//
//  Pulsator.swift
//  Pulsator
//
//  Created by Shuichi Tsutsumi on 4/9/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//  Objective-C version: https://github.com/shu223/PulsingHalo


import UIKit
import QuartzCore

internal let kPulsatorAnimationKey = "pulsator"

public class Pulsator: CAReplicatorLayer, CAAnimationDelegate {

    private let pulse = CALayer()
    private var animationGroup: CAAnimationGroup!
    private var alpha: CGFloat = 0.45

    override public var backgroundColor: CGColor? {
        didSet {
            pulse.backgroundColor = backgroundColor
            let oldAlpha = alpha
            alpha = backgroundColor!.alpha
            if alpha != oldAlpha {
                recreate()
            }
        }
    }
    
    override public var repeatCount: Float {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.repeatCount = repeatCount
            }
        }
    }
    
    // MARK: - Public Properties

    /// The number of pulse.
    public var numPulse: Int = 1 {
        didSet {
            if numPulse < 1 {
                numPulse = 1
            }
            instanceCount = numPulse
            updateInstanceDelay()
        }
    }
    
    ///	The radius of pulse.
    public var radius: CGFloat = 60 {
        didSet {
            updatePulse()
        }
    }
    
    /// The animation duration in seconds.
    public var animationDuration: TimeInterval = 3 {
        didSet {
            updateInstanceDelay()
        }
    }
    
    /// If this property is `true`, the instanse will be automatically removed
    /// from the superview, when it finishes the animation.
    public var autoRemove = false
    
    /// fromValue for radius
    /// It must be smaller than 1.0
    public var fromValueForRadius: Float = 0.0 {
        didSet {
            if fromValueForRadius >= 1.0 {
                fromValueForRadius = 0.0
            }
            recreate()
        }
    }
    
    /// The value of this property should be ranging from @c 0 to @c 1 (exclusive).
    public var keyTimeForHalfOpacity: Float = 0.2 {
        didSet {
            recreate()
        }
    }
    
    /// The animation interval in seconds.
    public var pulseInterval: TimeInterval = 0
    
    /// A function describing a timing curve of the animation.
    public var timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault) {
        didSet {
            if let animationGroup = animationGroup {
                animationGroup.timingFunction = timingFunction
            }
        }
    }
    
    /// The value of this property showed a pulse is started
    public var isPulsating: Bool {
        if let keys = pulse.animationKeys() {
            return keys.count > 0
        }
        return false
    }
    
    // MARK: - Initializer

    override public init() {
        super.init()
        
        setupPulse()
        
        instanceDelay = 1
        repeatCount = MAXFLOAT
        backgroundColor = UIColor(
            red: 0, green: 0.455, blue: 0.756, alpha: 0.45).cgColor
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(recreate),
                                                         name: NSNotification.Name.UIApplicationDidBecomeActive,
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
    
    private func setupPulse() {
        pulse.contentsScale = UIScreen.main.scale
        pulse.opacity = 0
        addSublayer(pulse)
        updatePulse()
    }
    
    private func setupAnimateionGroup() {
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
    
    private func updatePulse() {
        let diameter: CGFloat = radius * 2
        pulse.bounds = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: diameter, height: diameter))
        pulse.cornerRadius = radius
        pulse.backgroundColor = backgroundColor
    }
    
    private func updateInstanceDelay() {
        guard numPulse >= 1 else { fatalError() }
        instanceDelay = (animationDuration + pulseInterval) / Double(numPulse)
    }
    
    // MARK: - Internal Methods
    
    internal func recreate() {
        guard animationGroup != nil else { return }        // Not need to be recreated.
        stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.start()
        }
    }
    
    // MARK: - Public Methods
    
    /// Start the animation.
    public func start() {
        setupPulse()
        setupAnimateionGroup()
        pulse.add(animationGroup, forKey: kPulsatorAnimationKey)
    }
    
    /// Stop the animation.
    public func stop() {
        pulse.removeAllAnimations()
        animationGroup = nil
    }
    
    
    // MARK: - Delegate methods for CAAnimation
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if pulse.animationKeys() != nil && pulse.animationKeys()!.count > 0 {
            pulse.removeAllAnimations()
        }
        pulse.removeFromSuperlayer()
        
        if autoRemove {
            removeFromSuperlayer()
        }
    }
}

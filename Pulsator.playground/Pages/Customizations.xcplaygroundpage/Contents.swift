//: [Previous](@previous)

import UIKit
import XCPlayground
import Pulsator

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
containerView.backgroundColor = UIColor.white
let sourceView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50))
sourceView.contentMode = .scaleAspectFit
sourceView.center = CGPoint(x: 200, y: 200)
sourceView.image = UIImage(imageLiteralResourceName: "IPhone_5s.png")
containerView.addSubview(sourceView)

let pulsator = Pulsator()

sourceView.layer.addSublayer(pulsator)
sourceView.superview?.layer.insertSublayer(pulsator, below: sourceView.layer)
pulsator.position = sourceView.center

// Customizations
pulsator.numPulse = 5
pulsator.radius = 200
pulsator.animationDuration = 5
pulsator.backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 1).cgColor

pulsator.start()


XCPlaygroundPage.currentPage.liveView = containerView

//: [Next](@next)

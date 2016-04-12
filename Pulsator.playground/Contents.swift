import UIKit
import XCPlayground
import Pulsator

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400))
containerView.backgroundColor = UIColor.whiteColor()
let sourceView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50))
sourceView.contentMode = .ScaleAspectFit
sourceView.center = CGPointMake(200, 200)
sourceView.image = [#Image(imageLiteral: "IPhone_5s.png")#]
containerView.addSubview(sourceView)

let pulsator = Pulsator()

sourceView.layer.addSublayer(pulsator)
sourceView.superview?.layer.insertSublayer(pulsator, below: sourceView.layer)
pulsator.position = sourceView.center

// Customizations
pulsator.numPulse = 5
pulsator.radius = 200
pulsator.animationDuration = 5
pulsator.backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 1).CGColor

pulsator.start()

XCPlaygroundPage.currentPage.liveView = containerView



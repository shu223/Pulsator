Pulsator
===========

[![Badge w/ Version](http://cocoapod-badges.herokuapp.com/v/Pulsator/badge.png)](http://cocoadocs.org/docsets/Pulsator)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Twitter](https://img.shields.io/badge/twitter-@shu223-blue.svg?style=flat)](http://twitter.com/shu223)

Pulse animation for iOS written with Swift.

![](demo.gif)
                    
Great For:

- **Pulses of Bluetooth, BTLE, beacons (iBeacon)**, etc.
- Map Annotations

##Installation

###CocoaPods

Add into your Podfile.

```:Podfile
pod "Pulsator"
```

Then `$ pod install`

###Carthage

Add into your Cartfile.

```:Cartfile
github "shu223/Pulsator"
```

Then `$ carthage update`


##How to use

Just **3 lines**!

Initiate and add to your view's layer, then call `start`!

```swift
let pulsator = Pulsator()
view.layer.addSublayer(pulsator)
pulsator.start()
```


##Customizations

###Number of Pulses

Use `numPulse` property.

```swift
pulsator.numPulse = 3
```

###Radius

Use `radius` property.

```swift
pulsator.radius = 240.0
```

###Color

Just set the `backgroundColor` property.

```swift
pulsator.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1).CGColor
```

###Animation Duration

Use following properties

- `animationDuration` : duration for each pulse
- `pulseInterval` : interval between pulses

###Easing

You can set the `timingFunction` property.


###Repeat

Use `repeatCount` property.


##Demo

You can try to change the `radius`,  `backgroundColor`  or other properties with the demo app.

- Example/PulsatorDemo.xcodeproj

<iframe src="https://appetize.io/embed/45kwjngp1xud45eeqhxqy8qqew?device=iphone6s&scale=75&autoplay=false&orientation=portrait&deviceColor=black" width="312px" height="653px" frameborder="0" scrolling="no"></iframe>




##Objective-C version

There is an ObjC version, but it's not maintained now.

- https://github.com/shu223/PulsingHalo

You can use Pulsator also with Objective-C.

```
#import "Pulsator-Swift.h"
```


##Author

**Shuichi Tsutsumi**

iOS freelancer in Japan. Welcome works from abroad!

- PAST WORKS:  [My Profile Summary](https://medium.com/@shu223/my-profile-summary-f14bfc1e7099#.vdh0i7clr)
- PROFILES: [LinkedIn](https://www.linkedin.com/profile/view?id=214896557)
- BLOG: [English](https://medium.com/@shu223/) / [Japanese](http://d.hatena.ne.jp/shu223/)
- CONTACTS:
  - [Twitter](https://twitter.com/shu223)
  - [Facebook](https://www.facebook.com/shuichi.tsutsumi)

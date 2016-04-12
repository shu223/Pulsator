Pulsator
===========

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

- https://github.com/shu223/PulsingHalo

##Author

**Shuichi Tsutsumi**

I'm an iOS freelancer in Japan, welcome works from abroad.

You can check my past works here: 

- [My Profile Summary — Medium](https://medium.com/@shu223/my-profile-summary-f14bfc1e7099#.vdh0i7clr)

Other contacts:

- [Twitter](https://twitter.com/shu223)
- [Facebook](https://www.facebook.com/shuichi.tsutsumi)
- [LinkedIn](https://www.linkedin.com/profile/view?id=214896557)
- [Blog (Japanese)](http://d.hatena.ne.jp/shu223/)



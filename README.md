# Linear Progress Bar (Material Design)

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

Linear Progress Bar (inspired by [Google Material Design](https://www.google.com/design/spec/components/progress-activity.html#progress-activity-types-of-indicators#)) for iOS written in Swift 3.0

Please feel free to make pull requests :)

![alt tag](https://github.com/PhilippeBoisney/LinearProgressBar/raw/master/demo.gif)

## INSTALLATION
####Manually
Simply add **LinearProgressBar.swift** file on your project.

####CocoaPods
You can use [Cocoapods](http://cocoapods.org/) to install `Linear Progress Bar` by adding it to your `Podfile`:
```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
	pod 'LinearProgressBarMaterial'
end
```
## USAGE
```swift
//Simply, Call Progress Bar
let linearBar = LinearProgressBar()

//Show and Start Animation
self.linearBar.show()

//Show Specific Progress
self.linearBar.showProgress(progress: 0.5)

//Dismiss
self.linearBar.dismiss()
```
**OPTIONS**
```swift
//Change background color
linearBar.backgroundColor = UIColor(red:0.68, green:0.81, blue:0.72, alpha:1.0)
linearBar.progressBarColor = UIColor(red:0.26, green:0.65, blue:0.45, alpha:1.0)
```

## FEATURES

- [x] Multi-Device Full Support
- [x] Rotation Support
- [x] Material Design Effect
- [x] Swift 3 support

## Version
2.0


## Author

Philippe BOISNEY (phil.boisney(@)gmail.com)

# PeanutHandler

Version: 1.0.0

## Requirements

- Permissions:
    - Background data
    - Bluetooth central (background)
- iOS 8.0+
- A BLE-compatible device (iPhone 5s+, iPad 3+)

## Installation

PeanutHandler is available through [CocoaPods](http://cocoapods.org). To install it:
- Add the SensePods repo to your pods
- Add the PeanutHandler pod to your podfile, along with `use_frameworks!`
Here’s an example Podfile:

```ruby
use_frameworks!

source ‘https://github.com/CocoaPods/Specs.git'
source ‘https://gitlab.com/sen.se/SensePods.git'

target ‘MyApp’ do
    pod 'PeanutHandler'
end
```

## Quickstart

1. Add the required permissions to your project
1.1. In `Capabilities`, enable the ‘Uses Bluetooth LE accessories’ Background Mode
1.2. In your Info.plist, add the NSLocationAlwaysUsageDescription key (fill with a message explaining why you need to use the location)
2. Instantiate the PeanutManager singleton

```swift
let peanutManager = PeanutManager.sharedInstance()
```

3. Implement the PeanutManagerDelegate methods you need, for example within your ViewController
```swift
extension MyViewController: PeanutManagerDelegate {
    peanutManagerDidDiscoverPeanut(peanutManager: PeanutManager, peanutHandler: PeanutHandler) {
        print(‘Discovered peanut \(peanutHandler)’)
    }
}
```

4. (Optional) You can also listen for the corresponding notifications instead or on top of implementing the delegate methods:
```swift
let notificationCenter = NSNotificationCenter.defaultCenter()
notificationCenter.addObserverForName(
    PeanutManagerDidDiscoverPeanutNotification,
    object: peanutManager, queue: nil) {
        [unowned self] notification in
        if let peanutHandler = notification.userInfo?[PeanutManagerNotificationPeanutKey] as? PeanutHandler {
            print(“Discovered peanut \(peanutHandler)”)
        }
    }
```

  5. Start scanning for Peanuts

```swift
peanutManager.startScanning(false)
```

## Author

Axel Colin de Verdière, axel@sen.se


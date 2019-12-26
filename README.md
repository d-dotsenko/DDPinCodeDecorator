# DDPinCodeDecorator

[![Platform](https://img.shields.io/cocoapods/p/DDPinCodeDecorator.svg?style=flat)](http://cocoapods.org/pods/DDPinCodeDecorator)
[![License](https://img.shields.io/cocoapods/l/DDPinCodeDecorator.svg?style=flat)](http://cocoapods.org/pods/DDPinCodeDecorator)
[![Version](https://img.shields.io/cocoapods/v/DDPinCodeDecorator.svg?style=flat)](http://cocoapods.org/pods/DDPinCodeDecorator)
[![Swift 5](https://img.shields.io/badge/Swift-5-green.svg?style=flat)](https://developer.apple.com/swift/)


Pin Code Decorator allows you to create a awesome controller for entering password and PIN.

<img src="Info/DDPinCodeDecorator.gif?raw=true" alt="DDPinCodeDecorator" width=320>

## Installation

### CocoaPods

To install `DDPinCodeDecorator` via [CocoaPods](http://cocoapods.org), add the following line to your Podfile:

```
pod 'DDPinCodeDecorator'
```

After installing the cocoapod into your project import `DDPinCodeDecorator` with:

```
import DDPinCodeDecorator
```

### Manually

Add `DDPinCodeDecorator` folder to your Xcode project.

## Usage

See the example Xcode project.

### Basic setup

Create the `DDPinCodeDecorator` instance that confirms `DDPinCodeDecoratorProtocol` protocol.
```swift
let pinCodeDecorator: DDPinCodeDecoratorProtocol = DDPinCodeDecorator(frame: frame)
```
For minimum functionality you must set folowing parameters:

```swift
/*
The array with secure images.
The number of pictures is equal to the number of symbols (icons).
*/
var secureImagesArray: [UIImage] { get set }

/*
The image for initial display of all icons
*/
var emptyImage: UIImage { get set }
```

Set `delegate` and implement the following `delegate` methods of `DDPinCodeDecoratorOutput`:

```swift
/*
Optional
Called when all symbols are set
*/
func provideResult(module: DDPinCodeDecoratorProtocol, result: String)
```

Add `view` of `DDPinCodeDecorator` as `subview`.

```swift
/*
The view that the decorator manages.
*/
var view: UITextField? { get }
```

To add or remove characters, use the methods:

```swift
func addSymbol(_ symbol: String)
func delSymbol()
```

### Consider an example

```swift
let pinCodeDecorator: DDPinCodeDecoratorProtocol = DDPinCodeDecorator(frame: .zero)

pinCodeDecorator.delegate = self
pinCodeDecorator.secureImagesArray = appleImages    // is not empty array needed
pinCodeDecorator.emptyImage = emptyAppleImage       // is not nil needed
pinCodeDecorator.successImage = successAppleImage
pinCodeDecorator.unsuccessImage = unsuccessAppleImage
pinCodeDecorator.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
pinCodeDecorator.shadow = DDPinCodeDecoratorShadowModel(color: UIColor.black,
opacity: 0.5,
offSet: CGSize(width: 1, height: 1),
radius: 5,
scale: true)
pinCodeDecorator.font = UIFont.systemFont(ofSize: 24)
pinCodeDecorator.symbolOffset = UIOffset(horizontal: 0, vertical: 3)
pinCodeDecorator.secureDelay = 0.2
pinCodeDecorator.isEnableKeyboard = false

guard let appleView = pinCodeDecorator.view else { return }
pinCodeContenView.addSubview(appleView)

...

// in some method someButtonDidTouch e.g.
pinCodeDecorator.addSymbol(symbol)
// or
pinCodeDecorator.delSymbol()

...

// delegate method called
func provideResult(module: DDPinCodeDecoratorProtocol, result: String) {
    if module === self.pinCodeDecorator {
        if result == "1234" {
            module.showSuccess()
        } else {
            module.showUnsuccess()
            animate(module: module)
        }
    }
}
```

### Customization

```swift
/*
The view that the decorator manages.
*/
var view: UITextField? { get }

/*
The string that contains entered characters
Default is ""
*/
var resultString: String { get }

/*
The receiver’s delegate.
*/
var delegate: DDPinCodeDecoratorOutput? { get set}

/*
The font used to display the text.
Default is UIFont.systemFont(ofSize: 14)
*/
var font: UIFont? { get set }

/*
The shadow used to display the icons.
Default is:
color = UIColor.black
opacity = 0.5
offSet = CGSize(width: 1.0, height: 1.0)
radius = 5
scale = true
*/
var shadow: DDPinCodeDecoratorShadowModel? { get set }

/*
The delay from the symbol is displayed until the secure image is displayed
Default is 0.2
*/
var secureDelay: Double? { get set }

/*
A Boolean value that determines whether the keyboard is accessible
Default is true
*/
var isEnableKeyboard: Bool? { get set }

/*
The array with secure images.
The number of pictures is equal to the number of symbols (icons).
*/
var secureImagesArray: [UIImage] { get set }

/*
The image for initial display of all icons
*/
var emptyImage: UIImage { get set }

/*
The image of all icons to display successful input
*/
var successImage: UIImage { get set }

/*
The image of all icons to display unsuccessful input
*/
var unsuccessImage: UIImage { get set }

func addSymbol(_ symbol: String)
func delSymbol()

func showSuccess()
func showUnsuccess()

/*
Do not allow user to enter symbols
*/
func stopTapping()
func allowTapping()

func showKeyboard()
func hideKeyboard()

/*
Display all icons as initial and remove all symbols
*/
func clear()

/*
Optional
Insets for all icons
Default is .zero
*/
var padding: UIEdgeInsets { get set }
var symbolOffset: UIOffset? { get set }
```

## Requirements

- iOS 10
- Xcode 10, Swift 5

## License

`DDPerspectiveTransform` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.

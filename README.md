![Version](https://img.shields.io/cocoapods/v/PHAssetResourceInputStream.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/PHAssetResourceInputStream.svg?style=flat)
![Swift](https://img.shields.io/badge/%20in-swift%202.2-orange.svg)

## Description

**PHAssetResourceInputStream** is a library that adds `NSInputStream` support for assets from Photos Framework. It is build on the top of [POSInputStreamLibrary](https://github.com/pavelosipov/POSInputStreamLibrary) and it uses [Safe](https://github.com/tidwall/Safe) under the hood to inverse the producer-like API of `PHAssetResourceManager` and make it consumer-friendly.

## Example

Creating a stream:

```swift
let inputStream = NSInputStream.inputStreamWithAssetResource(assetResource)
```

Setting an offset:

```swift
inputStream.setProperty(100, forKey: NSStreamFileCurrentOffsetKey)
```

Furthemore, the library provides a set of data structures that allow you to work with a data of `PHAssetResource` in a synchronous manner.

Bellow is the example of getting the size from a `PHAssetResource`:

```swift
let dataProducer = PHAssetResourceDataProducer(assetResource: assetResource)
var dataGenerator = DataGeneratorFromDataProducer(dataProducer: dataProducer)

do {
    var size = 0
    while let data = try dataGenerator.nextChunk() {
        size += data.length
    }
    print(size)
} catch {
    print("error occured")
}
```

## TODO
- [-] Add an example project
- [-] Add Travis CI support
- [-] Add tests for `PHAssetResourceInputStreamDataSource`
- [-] Update to `Swift 3.0`

## Installation

**PHAssetResourceInputStream** is available through [CocoaPods](http://cocoapods.org). To install, specify it in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'PHAssetResourceInputStream'
end
```

## License

**PHAssetResourceInputStream** is available under the MIT license. See the [LICENSE](https://github.com/fromcelticpark/PHAssetResourceInputStream/blob/master/LICENSE.md) file for more info.
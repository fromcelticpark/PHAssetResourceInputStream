[![Build Status](https://travis-ci.org/fromcelticpark/PHAssetResourceInputStream.svg?branch=master)](https://travis-ci.org/fromcelticpark/PHAssetResourceInputStream)
![Version](https://img.shields.io/cocoapods/v/PHAssetResourceInputStream.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/PHAssetResourceInputStream.svg?style=flat)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)


## Description

**PHAssetResourceInputStream** is a library that adds input stream support for assets from `Photos Framework`. It is build on the top of [POSInputStreamLibrary](https://github.com/pavelosipov/POSInputStreamLibrary) and it uses [bounded blocking queue](https://en.wikipedia.org/wiki/Producer–consumer_problem) under the hood to inverse the producer-like API of `PHAssetResourceManager` and makes it consumer-friendly.

## Example

Creating a stream:

```swift
let inputStream = InputStream.inputStream(withAssetResource: assetResource)
```

Setting an offset:

```swift
inputStream.setProperty(100, forKey: .fileCurrentOffsetKey)
```

Furthemore, the library provides a set of data structures that allows you to work with data of `PHAssetResource` in a synchronous manner.

Bellow is the example of getting the size from a `PHAssetResource`:

```swift
let dataProducer = PHAssetResourceDataProducer(assetResource: assetResource)
let dataGenerator = DataGeneratorFromDataProducer(dataProducer: dataProducer)

do {
    var size = 0
    while let data = try dataGenerator.nextChunk() {
        size += data.length
    }
    print(size)
} catch let error {
    print("Error occured: \(error)")
}
```

## TODO
- [-] Add an example project

## Installation

**PHAssetResourceInputStream** is available through [CocoaPods](http://cocoapods.org). To install, specify it in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'PHAssetResourceInputStream'
end
```

## License

**PHAssetResourceInputStream** is available under the MIT license. See the [LICENSE](https://github.com/fromcelticpark/PHAssetResourceInputStream/blob/master/LICENSE.md) file for more info.
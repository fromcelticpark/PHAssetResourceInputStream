//
//  PHAssetResourceInputStreamDataSource.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos
import POSInputStreamLibrary

@available(iOS 9.0, *)
@objc public final class PHAssetResourceInputStreamDataSource: NSObject, POSBlobInputStreamDataSource {
    private var readOffset: UInt64 = 0
    private var assetResource: PHAssetResource
    private var bytesGenerator: BytesGenerator

    public init(assetResource: PHAssetResource) {
        self.assetResource = assetResource
        self.bytesGenerator = bytesGeneratorForAssetResource(assetResource)
    }

    internal var _isOpenCompleted = false
    public dynamic private(set) var isOpenCompleted: Bool {
        get {
            return _isOpenCompleted
        }
        @objc(setOpenCompleted:) set {
            _isOpenCompleted = newValue
        }
    }

    internal var _isAtEnd = false
    public dynamic private(set) var isAtEnd: Bool {
        get {
            return _isAtEnd
        }
        @objc(setAtEnd:) set {
            _isAtEnd = newValue
        }
    }

    public var hasBytesAvailable: Bool {
        return isOpenCompleted && !isAtEnd
    }

    public dynamic private(set) var error: Error! = nil

    internal dynamic static func keyPathsForValuesAffectingHasBytesAvailable() -> Set<String> {
        return [
            POSBlobInputStreamDataSourceOpenCompletedKeyPath,
            POSBlobInputStreamDataSourceAtEndKeyPath
        ]
    }

    public func open() {
        isOpenCompleted = true
    }

    public func property(forKey key: String!) -> Any! {
        guard key == Stream.PropertyKey.fileCurrentOffsetKey.rawValue else {
            return nil
        }

        return NSNumber.init(value: readOffset + bytesGenerator.readOffset as UInt64)
    }

    public func setProperty(_ property: Any!, forKey key: String!) -> Bool {
        guard let number = property as? NSNumber , key == Stream.PropertyKey.fileCurrentOffsetKey.rawValue else {
            return false
        }

        readOffset = number.uint64Value
        bytesGenerator = bytesGeneratorForAssetResource(assetResource, fromOffset: readOffset)
        return true
    }

    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength: UInt) -> Int {
        do {
            let bytesRead = try bytesGenerator.read(from: buffer, maxLength: Int(maxLength))
            if bytesRead == 0 {
                isAtEnd = true
            }
            return bytesRead
        } catch let error {
            self.error = error
            return -1
        }
    }

    public func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>!, length bufferLength: UnsafeMutablePointer<UInt>!) -> Bool {
        return false
    }

}

@available(iOS 9.0, *)
private func bytesGeneratorForAssetResource(_ assetResource: PHAssetResource, fromOffset offset: UInt64 = 0) -> BytesGenerator {
    let dataProducer = PHAssetResourceDataProducer(assetResource: assetResource)
    var dataGenerator: DataGenerator = DataGeneratorFromDataProducer(dataProducer: dataProducer)
    if offset > 0 {
        dataGenerator = DataGeneratorWithOffset(dataGenerator: dataGenerator, offset: offset)
    }
    let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)
    return bytesGenerator
}

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

@objc public final class PHAssetResourceInputStreamDataSource: NSObject, POSBlobInputStreamDataSource {
    private var readOffset: UInt64 = 0
    private var assetResource: PHAssetResource
    private var bytesGenerator: BytesGenerator

    public init(assetResource: PHAssetResource) {
        self.assetResource = assetResource
        self.bytesGenerator = bytesGeneratorForAssetResource(assetResource)
    }

    private var _openCompleted = false
    public dynamic private(set) var openCompleted: Bool {
        set {
            _openCompleted = newValue
        }
        @objc(isOpenCompleted) get {
            return _openCompleted
        }
    }

    public var hasBytesAvailable: Bool {
        return openCompleted && !atEnd
    }

    private var _atEnd = false
    public dynamic private(set) var atEnd: Bool {
        set {
            _atEnd = newValue
        }
        @objc(isAtEnd) get {
            return _atEnd
        }
    }
    public dynamic private(set) var error: NSError! = nil

    internal dynamic static func keyPathsForValuesAffectingHasBytesAvailable() -> Set<String> {
        return [
            POSBlobInputStreamDataSourceOpenCompletedKeyPath,
            POSBlobInputStreamDataSourceAtEndKeyPath
        ]
    }

    public func open() {
        openCompleted = true
    }

    public func propertyForKey(key: String!) -> AnyObject! {
        guard key == NSStreamFileCurrentOffsetKey else {
            return nil
        }

        return NSNumber.init(unsignedLongLong: readOffset + bytesGenerator.readOffset)
    }

    public func setProperty(property: AnyObject!, forKey key: String!) -> Bool {
        guard let number = property as? NSNumber where key == NSStreamFileCurrentOffsetKey else {
            return false
        }

        readOffset = number.unsignedLongLongValue
        bytesGenerator = bytesGeneratorForAssetResource(assetResource, fromOffset: readOffset)
        return true
    }

    public func read(buffer: UnsafeMutablePointer<UInt8>, maxLength: UInt) -> Int {
        do {
            let bytesRead = try bytesGenerator.read(buffer, maxLength: Int(maxLength))
            if bytesRead == 0 {
                atEnd = true
            }
            return bytesRead
        } catch let error as NSError {
            self.error = error
            return -1
        }
    }

    public func getBuffer(buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>>, length bufferLength: UnsafeMutablePointer<UInt>) -> Bool {
        return false
    }

}

private func bytesGeneratorForAssetResource(assetResource: PHAssetResource, fromOffset offset: UInt64 = 0) -> BytesGenerator {
    let dataProducer = PHAssetResourceDataProducer(assetResource: assetResource)
    var dataGenerator: DataGenerator = DataGeneratorFromDataProducer(dataProducer: dataProducer)
    if offset > 0 {
        dataGenerator = DataGeneratorWithOffset(dataGenerator: dataGenerator, offset: offset)
    }
    let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)
    return bytesGenerator
}
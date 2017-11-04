//
//  InputStreamDataSource.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos
import POSInputStreamLibrary

@objc public final class InputStreamDataSource: NSObject, POSBlobInputStreamDataSource {
    private var readOffset: UInt64 = 0
    private var bytesGenerator: BytesGenerator
    private let bytesGeneratorFactory: BytesGeneratorFactory

    public init(bytesGeneratorFactory: BytesGeneratorFactory) {
        self.bytesGenerator = bytesGeneratorFactory.buildBytesGenerator(startingFromOffset: 0)
        self.bytesGeneratorFactory = bytesGeneratorFactory
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

    @objc internal dynamic static func keyPathsForValuesAffectingHasBytesAvailable() -> Set<String> {
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

        return NSNumber(value: readOffset + bytesGenerator.readOffset)
    }

    public func setProperty(_ property: Any!, forKey key: String!) -> Bool {
        guard let number = property as? NSNumber , key == Stream.PropertyKey.fileCurrentOffsetKey.rawValue else {
            return false
        }

        readOffset = number.uint64Value
        bytesGenerator = bytesGeneratorFactory.buildBytesGenerator(startingFromOffset: readOffset)
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

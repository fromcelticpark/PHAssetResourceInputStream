//
//  NSData.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

extension Data {
    static func dataWithRepeatedValue(_ value: UInt8, ofLength length: Int) -> Data {
        var bytes = [UInt8](repeating: value, count: length)
        return Data.init(bytes: UnsafePointer<UInt8>(&bytes), count: length)
    }

    static func emptyDataOfLength(_ length: Int) -> Data {
        return dataWithRepeatedValue(0, ofLength: length)
    }

    static func chunksOfEmptyData(count: Int, length: Int) -> [Data] {
        return (0..<count).map { _ in emptyDataOfLength(length) }
    }

    static func chunksOfData(count: UInt8, ofLength length: Int) -> [Data] {
        return (0..<count).map { i in
            return Data.dataWithRepeatedValue(i, ofLength: length)
        }
    }
}

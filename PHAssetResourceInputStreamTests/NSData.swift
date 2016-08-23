//
//  NSData.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

extension NSData {
    static func dataWithRepeatedValue(value: UInt8, ofLength length: Int) -> NSData {
        var bytes = [UInt8](count: length, repeatedValue: value)
        return NSData.init(bytes: &bytes, length: length)
    }

    static func emptyDataOfLength(length: Int) -> NSData {
        return dataWithRepeatedValue(0, ofLength: length)
    }

    static func chunksOfEmptyData(count count: Int, length: Int) -> [NSData] {
        return (0..<count).map { _ in emptyDataOfLength(length) }
    }

    static func chunksOfData(count count: UInt8, ofLength length: Int) -> [NSData] {
        return (0..<count).map { i in
            return NSData.dataWithRepeatedValue(i, ofLength: length)
        }
    }
}
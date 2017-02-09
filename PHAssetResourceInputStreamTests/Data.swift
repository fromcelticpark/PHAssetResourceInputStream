//
//  Data.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

extension Data {
    static func emptyDataOfLength(_ length: Int) -> Data {
        return Data(repeating: 0, count: length)
    }

    static func chunksOfEmptyData(count: Int, length: Int) -> [Data] {
        return (0..<count).map { _ in emptyDataOfLength(length) }
    }

    static func chunksOfData(count: UInt8, ofLength length: Int) -> [Data] {
        return (0..<count).map { i in
            return Data(repeating: i, count: length)
        }
    }

    static func dataFromChunks(_ chunks: [Data]) -> Data {
        return chunks.reduce(Data(), { (result, chunk) -> Data in
            var newBytes = result
            newBytes.append(chunk)
            return newBytes
        })
    }
}

//
//  BytesGenerator.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public final class BytesGenerator {
    private let dataGenerator: DataGenerator
    private var chunk: NSData? = nil
    private var chunkLength: Int = 0
    private var chunkOffset: Int = 0
    private(set) var readOffset: UInt64 = 0

    public init(dataGenerator: DataGenerator) {
        self.dataGenerator = dataGenerator
    }

    public func read(buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) throws -> Int {
        if chunk == nil {
            // refill cache with new chunk
            if try refillCache() == false {
                return 0
            }
        }
        assert(chunk != nil)

        let readLength = min(chunkLength - chunkOffset, len)
        assert(readLength > 0)

        let range = NSRange(location: chunkOffset, length: readLength)
        chunk!.getBytes(buffer, range: range)
        chunkOffset += readLength
        readOffset += UInt64(readLength)

        dropCacheIfNeeded()

        return readLength
    }

    private func refillCache() throws -> Bool {
        guard let newChunk = try dataGenerator.nextChunk() else {
            // finished reading from data generator
            return false
        }

        chunk = newChunk
        chunkLength = newChunk.length
        chunkOffset = 0
        return true
    }

    private func dropCacheIfNeeded() {
        if chunkOffset == chunkLength {
            chunk = nil
            chunkLength = 0
            chunkOffset = 0
        }
    }
}
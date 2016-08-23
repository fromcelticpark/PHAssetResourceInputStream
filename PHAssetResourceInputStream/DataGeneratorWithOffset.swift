//
//  DataGeneratorWithOffset.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public final class DataGeneratorWithOffset: DataGenerator {
    private let dataGenerator: DataGenerator
    private let offset: UInt64
    private var currentOffset: UInt64 = 0

    public init(dataGenerator: DataGenerator, offset: UInt64) {
        self.dataGenerator = dataGenerator
        self.offset = offset
    }

    public func nextChunk() throws -> NSData? {
        // skip data chunks before offset
        while currentOffset < offset {
            guard let chunk = try dataGenerator.nextChunk() else {
                return nil
            }

            let chunkLength = UInt64(chunk.length)
            currentOffset += chunkLength

            // we just passed farther the offset
            if currentOffset > offset {
                let trimmedChunkLength = currentOffset - offset
                let trimmedChunkStart = chunkLength - trimmedChunkLength
                let range = NSRange(location: Int(trimmedChunkStart), length: Int(trimmedChunkLength))
                let trimmedChunk = chunk.subdataWithRange(range)
                return trimmedChunk
            }
        }

        guard let chunk = try dataGenerator.nextChunk() else {
            return nil
        }

        currentOffset += UInt64(chunk.length)
        
        return chunk
    }
}
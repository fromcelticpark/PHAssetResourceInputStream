//
//  DataGeneratorWithOffset.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
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

    public func nextChunk() throws -> Data? {
        // skip data chunks before offset
        while currentOffset < offset {
            guard let chunk = try dataGenerator.nextChunk() else {
                return nil
            }

            let chunkLength = chunk.count
            currentOffset += UInt64(chunkLength)

            // we just passed farther the offset
            if currentOffset > offset {
                let trimmedChunkLength = Int(currentOffset - offset)
                let trimmedChunkStart = chunkLength - trimmedChunkLength
                let range: Range<Int> = trimmedChunkStart..<trimmedChunkStart+trimmedChunkLength
                let trimmedChunk = chunk.subdata(in: range)
                return trimmedChunk
            }
        }

        guard let chunk = try dataGenerator.nextChunk() else {
            return nil
        }

        currentOffset += UInt64(chunk.count)
        
        return chunk as Data
    }
}

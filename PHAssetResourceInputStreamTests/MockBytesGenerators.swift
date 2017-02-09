//
//  MockBytesGenerators.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 10/02/2017.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
@testable import PHAssetResourceInputStream

class MockBytesGenerator: BytesGenerator {
    private var chunks: [Data]
    private var numberOfCalls = 0
    private(set) var readOffset: UInt64 = 0

    init(chunks: [Data]) {
        self.chunks = chunks
    }

    convenience init() {
        self.init(chunks: [])
    }

    func read(from buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) throws -> Int {
        if numberOfCalls == chunks.count {
            return 0
        } else {
            let chunk = chunks[numberOfCalls]
            let chunkLength = chunk.count
            let range: Range<Int> = 0..<chunkLength
            chunk.copyBytes(to: buffer, from: range)

            numberOfCalls += 1
            readOffset += UInt64(chunkLength)
            return chunkLength
        }
    }
}

class ErrorBytesGenerator: BytesGenerator {
    private(set) var readOffset: UInt64 = 0
    let error: Error

    init(error: Error) {
        self.error = error
    }

    func read(from buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) throws -> Int {
        throw error
    }
}

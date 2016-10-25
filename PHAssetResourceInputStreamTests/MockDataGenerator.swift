//
//  MockDataGenerator.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
@testable import PHAssetResourceInputStream

class MockDataGenerator: DataGenerator {
    fileprivate let chunks: [Data]
    fileprivate var index = 0

    init(chunks: [Data]) {
        self.chunks = chunks
    }

    func nextChunk() -> Data? {
        guard index < chunks.count else {
            return nil
        }

        let chunk = chunks[index]
        index += 1
        return chunk
    }

    static func empty() -> MockDataGenerator {
        return MockDataGenerator(chunks: [])
    }
}

//
//  BlockBasedBytesGeneratorFactory.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 09/02/2017.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
@testable import PHAssetResourceInputStream

class BlockBasedBytesGeneratorFactory: BytesGeneratorFactory {
    private let block: (UInt64) -> BytesGenerator

    init(block: @escaping (UInt64) -> BytesGenerator) {
        self.block = block
    }

    func buildBytesGenerator(startingFromOffset offset: UInt64) -> BytesGenerator {
        return block(offset)
    }
}

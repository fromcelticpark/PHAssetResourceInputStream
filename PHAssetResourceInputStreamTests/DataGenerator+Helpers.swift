//
//  DataGenerator+Helpers.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
@testable import PHAssetResourceInputStream

extension DataGenerator {
    func generate() -> AnyGenerator<NSData> {
        return AnyGenerator(body: { () -> NSData? in
            return (try? self.nextChunk()).flatMap({ $0 })
        })
    }

    func sequence() -> AnySequence<NSData> {
        return AnySequence(generate())
    }

    func allValues() -> [NSData] {
        return Array(sequence())
    }
}
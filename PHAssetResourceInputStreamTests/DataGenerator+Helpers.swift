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
    func generate() -> AnyIterator<Data> {
        return AnyIterator(body: { () -> Data? in
            return (try? self.nextChunk()).flatMap({ $0 })
        })
    }

    func sequence() -> AnySequence<Data> {
        return AnySequence(generate())
    }

    func allValues() -> [Data] {
        return Array(sequence())
    }
}

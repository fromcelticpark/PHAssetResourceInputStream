//
//  AssetBytesGeneratorFactory.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 09/02/2017.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos

@available(iOS 9.0, *)
public final class AssetBytesGeneratorFactory: BytesGeneratorFactory {
    private let assetResource: PHAssetResource

    public init(assetResource: PHAssetResource) {
        self.assetResource = assetResource
    }

    public func buildBytesGenerator(startingFromOffset offset: UInt64) -> BytesGenerator {
        let dataProducer = PHAssetResourceDataProducer(assetResource: assetResource)
        var dataGenerator: DataGenerator = DataGeneratorFromDataProducer(dataProducer: dataProducer)
        if offset > 0 {
            dataGenerator = DataGeneratorWithOffset(dataGenerator: dataGenerator, offset: offset)
        }
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)
        return bytesGenerator
    }
}

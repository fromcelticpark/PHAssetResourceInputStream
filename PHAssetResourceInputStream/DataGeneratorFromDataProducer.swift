//
//  DataGeneratorFromDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos
import Safe

public final class DataGeneratorFromDataProducer: DataGenerator {
    private enum AssetData {
        case Data(NSData)
        case Error(NSError)
    }

    private let dataProducer: DataProducer
    private let chunks = Chan<AssetData>()
    private var opened = false
    private var cancellable: Cancellable?

    public init(dataProducer: DataProducer) {
        self.dataProducer = dataProducer
    }

    deinit {
        cancellable?.cancel()
        if opened {
            // dispose of data added to chunks
            while let _ = <-chunks {}
        }
    }

    private func open() {
        cancellable =
            dataProducer.requestData(
                withCallback: { [chunks] data in
                    chunks <- .Data(data)
                },
                completion: { [chunks] error in
                    if let error = error {
                        chunks <- .Error(error)
                    }
                    chunks.close()
                })
    }

    public func nextChunk() throws -> NSData? {
        if !opened {
            opened = true
            open()
        }

        guard let assetData = <-chunks else {
            return nil
        }

        switch assetData {
        case let .Data(data):
            return data
        case let .Error(error):
            throw error
        }
    }
}
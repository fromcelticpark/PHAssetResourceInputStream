//
//  DataGeneratorFromDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos

public final class DataGeneratorFromDataProducer: DataGenerator {
    private enum AssetData {
        case Data(NSData)
        case Error(NSError)
    }

    private let dataProducer: DataProducer
    private let queue = BoundedBlockingQueue<AssetData>()
    private var opened = false
    private var cancellable: Cancellable?

    public init(dataProducer: DataProducer) {
        self.dataProducer = dataProducer
    }

    deinit {
        cancellable?.cancel()
        if opened {
            // dispose of data added to chunks
            while let _ = queue.receive() {}
        }
    }

    private func open() {
        cancellable =
            dataProducer.requestData(
                withCallback: { [queue] data in
                    queue.send(.Data(data))
                },
                completion: { [queue] error in
                    if let error = error {
                        queue.send(.Error(error))
                    }
                    queue.close()
                })
    }

    public func nextChunk() throws -> NSData? {
        if !opened {
            opened = true
            open()
        }

        guard let assetData = queue.receive() else {
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

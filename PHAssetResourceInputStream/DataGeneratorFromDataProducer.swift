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
    fileprivate enum AssetData {
        case data(Foundation.Data)
        case error(NSError)
    }

    fileprivate let dataProducer: DataProducer
    fileprivate let queue = BoundedBlockingQueue<AssetData>()
    fileprivate var opened = false
    fileprivate var cancellable: Cancellable?

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

    fileprivate func open() {
        cancellable =
            dataProducer.requestData(
                withCallback: { [queue] data in
                    queue.send(.data(data))
                },
                completion: { [queue] error in
                    if let error = error {
                        queue.send(.error(error))
                    }
                    queue.close()
                })
    }

    public func nextChunk() throws -> Data? {
        if !opened {
            opened = true
            open()
        }

        guard let assetData = queue.receive() else {
            return nil
        }

        switch assetData {
        case let .data(data):
            return data
        case let .error(error):
            throw error
        }
    }
}

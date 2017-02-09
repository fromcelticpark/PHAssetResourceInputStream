//
//  DataGeneratorFromDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
import Photos

public final class DataGeneratorFromDataProducer: DataGenerator {
    private enum AssetData {
        case data(Data)
        case error(Error)
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

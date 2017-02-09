//
//  MockDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 24/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
@testable import PHAssetResourceInputStream

class MockDataProducer: DataProducer {
    private let chunks: [Data]
    private let error: Error?
    private let queue: OperationQueue
    private let cancellable: Cancellable

    init(
        queue: OperationQueue = OperationQueue.serialQueue(),
        chunks: [Data],
        error: Error? = nil,
        cancellable: Cancellable = CancellationToken.empty)
    {
        self.queue = queue
        self.chunks = chunks
        self.error = error
        self.cancellable = cancellable
    }

    func requestData(withCallback callback: @escaping (Data) -> Void, completion: @escaping (Error?) -> Void) -> Cancellable {
        for chunk in chunks {
            let operation = dataOperation(from: chunk, callback: callback)
            queue.addOperation(operation)
        }
        let operation = completionOperation(from: error, completion: completion)
        queue.addOperation(operation)
        return cancellable
    }

    private func dataOperation(from data: Data, callback: @escaping (Data) -> Void) -> Operation {
        return BlockOperation {
            callback(data)
        }
    }

    private func completionOperation(from error: Error?, completion: @escaping (Error?) -> Void) -> Operation {
        return BlockOperation {
            completion(error)
        }
    }
}

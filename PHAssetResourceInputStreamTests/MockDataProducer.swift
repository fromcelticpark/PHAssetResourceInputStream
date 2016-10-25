//
//  MockDataProducer.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 24/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation
@testable import PHAssetResourceInputStream

class MockDataProducer: DataProducer {
    fileprivate let chunks: [Data]
    fileprivate let error: NSError?
    fileprivate let queue: OperationQueue
    fileprivate let cancellable: Cancellable

    init(
        queue: OperationQueue = OperationQueue.serialQueue(),
        chunks: [Data],
        error: NSError? = nil,
        cancellable: Cancellable = CancellationToken.empty)
    {
        self.queue = queue
        self.chunks = chunks
        self.error = error
        self.cancellable = cancellable
    }

    func requestData(withCallback callback: (Data) -> Void, completion: (NSError?) -> Void) -> Cancellable {
        for chunk in chunks {
            let operation = dataOperation(from: chunk, callback: callback)
            queue.addOperation(operation)
        }
        let operation = completionOperation(from: error, completion: completion)
        queue.addOperation(operation)
        return cancellable
    }

    fileprivate func dataOperation(from data: Data, callback: @escaping (Data) -> Void) -> Operation {
        return BlockOperation.init(block: {
            callback(data)
        })
    }

    fileprivate func completionOperation(from error: NSError?, completion: @escaping (NSError?) -> Void) -> Operation {
        return BlockOperation.init(block: {
            completion(error)
        })
    }
}

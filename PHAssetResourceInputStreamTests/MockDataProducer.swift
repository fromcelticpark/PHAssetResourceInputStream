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
    private let chunks: [NSData]
    private let error: NSError?
    private let queue: NSOperationQueue
    private let cancellable: Cancellable

    init(
        queue: NSOperationQueue = NSOperationQueue.serialQueue(),
        chunks: [NSData],
        error: NSError? = nil,
        cancellable: Cancellable = CancellationToken.empty)
    {
        self.queue = queue
        self.chunks = chunks
        self.error = error
        self.cancellable = cancellable
    }

    func requestData(withCallback callback: NSData -> Void, completion: NSError? -> Void) -> Cancellable {
        for chunk in chunks {
            let operation = dataOperation(from: chunk, callback: callback)
            queue.addOperation(operation)
        }
        let operation = completionOperation(from: error, completion: completion)
        queue.addOperation(operation)
        return cancellable
    }

    private func dataOperation(from data: NSData, callback: NSData -> Void) -> NSOperation {
        return NSBlockOperation.init(block: {
            callback(data)
        })
    }

    private func completionOperation(from error: NSError?, completion: NSError? -> Void) -> NSOperation {
        return NSBlockOperation.init(block: {
            completion(error)
        })
    }
}

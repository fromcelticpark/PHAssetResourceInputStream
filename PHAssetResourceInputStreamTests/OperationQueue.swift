//
//  OperationQueue.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 24/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

extension OperationQueue {
    static func serialQueue() -> OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }
}

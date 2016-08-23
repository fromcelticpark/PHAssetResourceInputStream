//
//  NSOperationQueue.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 24/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

extension NSOperationQueue {
    static func serialQueue() -> NSOperationQueue {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }
}
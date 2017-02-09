//
//  BoundedBlockingQueue.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 25/10/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

internal class BoundedBlockingQueue<T> {
    private let capacity: Int
    private var queue = [T]()
    private var closed = false
    private let cond = NSCondition()

    init(capacity: Int = 0){
        self.capacity = capacity
    }

    func close(){
        cond.lock()
        defer { cond.unlock() }
        closed = true
        cond.broadcast()
    }

    func send(_ msg: T) {
        cond.lock()
        defer { cond.unlock() }
        if closed {
            assertionFailure("Send on closed channel")
        }
        queue.append(msg)
        cond.broadcast()
        while queue.count > capacity {
            cond.wait()
        }
    }

    func receive() -> T? {
        cond.lock()
        defer { cond.unlock() }
        while true {
            if queue.count > 0 {
                let msg = queue.remove(at: 0)
                cond.broadcast()
                return msg
            }
            if closed {
                return nil
            }
            cond.wait()
        }
    }
    
}

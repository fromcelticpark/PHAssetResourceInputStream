//
//  BoundedBlockingQueueTests.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 25/10/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import XCTest
@testable import PHAssetResourceInputStream

class BoundedBlockingQueueTests: XCTestCase {

    let backgroundQueue = DispatchQueue.global(qos: .background)

    func testShouldCloseQueue() {
        let queue = BoundedBlockingQueue<Int>()
        queue.close()

        let value = queue.receive()
        XCTAssertEqual(value, nil, "Should immediately return empty value after closing a queue.")
    }

    func testShouldCorrectlyReadFromNonBufferedQueue() {
        let count = 100
        var result = [Int]()
        let expected = Array(0..<count)
        let queue = BoundedBlockingQueue<Int>()
        let done = BoundedBlockingQueue<Bool>()

        backgroundQueue.asyncAfter(deadline: DispatchTime.now() + 0.5) { 
            result = readAllValuesFromQueue(queue)
            done.send(true)

        }

        writeValuesToQueue(queue, count: count)

        queue.close()
        _ = done.receive()
        XCTAssertEqual(result, expected, "The expected result is incorrect.")
    }

    func testShouldCorrectlyReadFromBufferedQueue() {
        let count = 100
        var result = [Int]()
        let expected = Array(0..<count)
        let queue = BoundedBlockingQueue<Int>(capacity: 10)
        let done = BoundedBlockingQueue<Bool>()

        backgroundQueue.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            result = readAllValuesFromQueue(queue)
            done.send(true)
        }

        writeValuesToQueue(queue, count: count)

        queue.close()
        _ = done.receive()
        XCTAssert(result == expected, "The expected result is incorrect. ")
    }

    func testShouldCorrectlyWriteToQueue() {
        checkWriteToBufferedQueueWith(capacity: 0)
        checkWriteToBufferedQueueWith(capacity: 10)
        checkWriteToBufferedQueueWith(capacity: 100)
    }

    func checkWriteToBufferedQueueWith(capacity: Int) {
        let count = capacity * 100
        let queue = BoundedBlockingQueue<Int>(capacity: capacity)

        var readingKickedIn = false
        var numberOfWritesBeforeReadingKickedIn = 0

        backgroundQueue.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            readingKickedIn = true
            readAllValuesFromQueue(queue)
        }

        for i in 0..<count {
            queue.send(i)
            if !readingKickedIn {
                numberOfWritesBeforeReadingKickedIn += 1
            }
        }

        queue.close()
        XCTAssertEqual(numberOfWritesBeforeReadingKickedIn, capacity,
                       "Expected to make \(capacity) non blocking writes. Actually performed: \(numberOfWritesBeforeReadingKickedIn).")
    }

}

private func writeValuesToQueue(_ queue: BoundedBlockingQueue<Int>, count: Int) {
    for i in 0..<count {
        queue.send(i)
    }
}

@discardableResult
private func readAllValuesFromQueue(_ queue: BoundedBlockingQueue<Int>) -> [Int] {
    var result = [Int]()
    while let i = queue.receive() {
        result.append(i)
    }
    return result
}

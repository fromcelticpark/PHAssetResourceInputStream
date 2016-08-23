//
//  DataGeneratorFromDataProducerTests.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 24/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import XCTest
import PHAssetResourceInputStream

class DataGeneratorFromDataProducerTests: XCTestCase {
    func testShouldReadAllData() {
        let dataChunks = NSData.chunksOfData(count: 10, ofLength: 100)
        let dataGenerator = dataGeneratorWithChunks(dataChunks)

        let allValues = dataGenerator.allValues()

        XCTAssertEqual(dataChunks, allValues)
    }

    func testShouldThrowError() {
        let error = NSError(domain: "domain", code: 1, userInfo: nil)
        let dataGenerator = dataGeneratorWithChunks([], error: error)

        var receivedError: NSError? = nil
        do {
            _ = try dataGenerator.nextChunk()
        } catch let error as NSError {
            receivedError = error
        }

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError, error)
    }

    func testShouldNotBlockProducerQueueOnDeinit() {
        let queue: NSOperationQueue = NSOperationQueue.serialQueue()
        let dataChunks = NSData.chunksOfData(count: 3, ofLength: 100)
        let dataProducer = MockDataProducer(queue: queue, chunks: dataChunks)
        var dataGenerator: DataGeneratorFromDataProducer? = DataGeneratorFromDataProducer(dataProducer: dataProducer)

        _ = try? dataGenerator!.nextChunk()
        dataGenerator = nil

        let queueExpectation = expectationWithDescription("Queue should not be blocked after deinit")
        queue.addOperation(NSBlockOperation(block: {
            queueExpectation.fulfill()
        }))

        waitForExpectationsWithTimeout(0.5, handler: nil)
    }

    func testShouldCallCancelOnDeinit() {
        var calledCancel = false
        let cancellationToken = CancellationToken { calledCancel = true }
        let dataChunks = NSData.chunksOfData(count: 3, ofLength: 100)
        let dataProducer = MockDataProducer(chunks: dataChunks, cancellable: cancellationToken)
        var dataGenerator: DataGeneratorFromDataProducer? = DataGeneratorFromDataProducer(dataProducer: dataProducer)

        _ = try? dataGenerator!.nextChunk()
        dataGenerator = nil

        XCTAssertTrue(calledCancel)
    }

    func testShouldNotBlockOnDeinitIfNoDataHasBeenRead() {
        let queue: NSOperationQueue = NSOperationQueue.serialQueue()
        let dataProducer = MockDataProducer(chunks: [])
        var dataReader: DataGeneratorFromDataProducer? = DataGeneratorFromDataProducer(dataProducer: dataProducer)
        silenceCompilerWarningAboutUnreadVariable(dataReader)

        queue.addOperation(NSBlockOperation(block: {
            dataReader = nil
        }))

        let queueExpectation = expectationWithDescription("DataReaderFromDataProducer should not be blocked on deinit")
        queue.addOperation(NSBlockOperation(block: {
            queueExpectation.fulfill()
        }))

        waitForExpectationsWithTimeout(0.5, handler: nil)
    }

}

private func dataGeneratorWithChunks(chunks: [NSData], error: NSError? = nil) -> DataGeneratorFromDataProducer {
    let dataProducer = MockDataProducer(chunks: chunks, error: error)
    let dataGenerator = DataGeneratorFromDataProducer(dataProducer: dataProducer)
    return dataGenerator
}

private func silenceCompilerWarningAboutUnreadVariable<T>(variable: T) {
    // do nothing
}
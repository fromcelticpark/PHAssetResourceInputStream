//
//  InputStreamDataSourceTests.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 09/02/2017.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import XCTest
import POSInputStreamLibrary
@testable import PHAssetResourceInputStream

private let readLength = 1024

class InputStreamDataSourceTests: XCTestCase {
    func testShouldBeInitializedWithDefaultValues() {
        let factory = factoryFromBytesGenerator(MockBytesGenerator())
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)

        XCTAssertEqual(dataSource.isOpenCompleted, false)
        XCTAssertEqual(dataSource.isAtEnd, false)
        XCTAssertEqual(dataSource.hasBytesAvailable, false)
        XCTAssertNil(dataSource.error)
        XCTAssertEqual(dataSource.readOffset, 0)
    }

    func testShouldTriggerKVONotificationsOnOpen() {
        let factory = factoryFromBytesGenerator(MockBytesGenerator())
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)
        let openCompletedListener = KVOListener(object: dataSource, keyPath: POSBlobInputStreamDataSourceOpenCompletedKeyPath)
        let hasBytesAvailableListener = KVOListener(object: dataSource, keyPath: POSBlobInputStreamDataSourceHasBytesAvailableKeyPath)

        dataSource.open()

        XCTAssertEqual(openCompletedListener.numberOfCalls, 1)
        XCTAssertEqual(hasBytesAvailableListener.numberOfCalls, 1)
        XCTAssertEqual(dataSource.isOpenCompleted, true)
        XCTAssertEqual(dataSource.hasBytesAvailable, true)
    }

    func testShouldTriggerKVONotificationsOnEnd() {
        let factory = factoryFromBytesGenerator(MockBytesGenerator())
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)

        dataSource.open()
        let hasBytesAvailableListener = KVOListener(object: dataSource, keyPath: POSBlobInputStreamDataSourceHasBytesAvailableKeyPath)
        let atEndListener = KVOListener(object: dataSource, keyPath: POSBlobInputStreamDataSourceAtEndKeyPath)
        _ = readAllData(from: dataSource)

        XCTAssertEqual(hasBytesAvailableListener.numberOfCalls, 1)
        XCTAssertEqual(atEndListener.numberOfCalls, 1)
        XCTAssertEqual(dataSource.hasBytesAvailable, false)
        XCTAssertEqual(dataSource.isAtEnd, true)
    }

    func testShouldTriggerKVONotificationsOnError() {
        let error = NSError(domain: "domain", code: 0, userInfo: nil)
        let factory = factoryFromBytesGenerator(ErrorBytesGenerator(error: error))
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)
        let errorListener = KVOListener(object: dataSource, keyPath: POSBlobInputStreamDataSourceErrorKeyPath)

        var buffer = [UInt8](repeating: 0, count: readLength)
        let dataRead = dataSource.read(&buffer, maxLength: UInt(readLength))

        XCTAssertEqual(dataRead, -1)
        XCTAssertEqual(errorListener.numberOfCalls, 1)
        XCTAssertEqual(dataSource.error as NSError, error)
    }

    func testShouldUpdateReadOffset() {
        var offset: UInt64 = 0
        let factory = BlockBasedBytesGeneratorFactory { readOffset in
            offset = readOffset
            return MockBytesGenerator()
        }
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)

        let newOffset: UInt64 = UInt64.max
        let valueWasUpdated = dataSource.setProperty(newOffset, forKey: Stream.PropertyKey.fileCurrentOffsetKey.rawValue)
        let offsetFromProperty = dataSource.readOffset

        XCTAssertEqual(valueWasUpdated, true)
        XCTAssertEqual(offset, newOffset)
        XCTAssertEqual(offsetFromProperty, newOffset)
    }

    func testShouldChangeReadOffset() {
        let bytesGenerator = MockBytesGenerator(chunks: [Data.emptyDataOfLength(readLength)])
        let factory = factoryFromBytesGenerator(bytesGenerator)
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)

        var buffer = [UInt8](repeating: 0, count: readLength)
        let _ = dataSource.read(&buffer, maxLength: UInt(readLength))
        let offsetFromProperty = dataSource.readOffset

        XCTAssertEqual(offsetFromProperty, UInt64(readLength))
    }

    func testShouldCorrectlyReadAllDataFromDataSource() {
        let chunks = [Data(repeating: 0, count: readLength),
                      Data(repeating: 1, count: readLength),
                      Data(repeating: 2, count: readLength)]
        let bytesGenerator = MockBytesGenerator(chunks: chunks)
        let factory = factoryFromBytesGenerator(bytesGenerator)
        let dataSource = InputStreamDataSource(bytesGeneratorFactory: factory)

        let data = readAllData(from: dataSource)
        
        XCTAssertEqual(data, Data.dataFromChunks(chunks))
    }
}

extension InputStreamDataSource {
    var readOffset: UInt64 {
        get {
            return property(forKey: Stream.PropertyKey.fileCurrentOffsetKey.rawValue) as! UInt64
        }
        set {
            _ = setProperty(newValue, forKey: Stream.PropertyKey.fileCurrentOffsetKey.rawValue)
        }
    }
}

private func factoryFromBytesGenerator(_ bytesGenerator: BytesGenerator) -> BytesGeneratorFactory {
    return BlockBasedBytesGeneratorFactory(block: { _ in
        return bytesGenerator
    })
}

private func readAllData(from dataSource: InputStreamDataSource) -> Data {
    var data = Data()
    var buffer = [UInt8](repeating: 0, count: readLength)

    var dataReadLength = 0
    repeat {
        dataReadLength = dataSource.read(&buffer, maxLength: UInt(readLength))
        if dataReadLength > 0 {
            data.append(&buffer, count: dataReadLength)
        }
    } while dataReadLength > 0

    return data
}

//
//  BytesGeneratorTests.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import XCTest
import PHAssetResourceInputStream

private let readLength = 1024
private let smallChunkLength = 500
private let bigChunkLength = 2000

class BytesGeneratorTests: XCTestCase {
    func testShouldReadNoDataFromEmptyDataProducer() {
        let dataGenerator = MockDataGenerator.empty()
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let data = readAllData(from: bytesGenerator)

        XCTAssertEqual(data, NSData())
    }

    func testShouldReadDataFromDataProducerWithSmallChunk() {
        let data = NSData.emptyDataOfLength(smallChunkLength)
        let dataGenerator = MockDataGenerator(chunks: [data])
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, data)
    }

    func testShouldReadDataFromDataProducerWithBigChunk() {
        let data = NSData.emptyDataOfLength(bigChunkLength)
        let dataGenerator = MockDataGenerator(chunks: [data])
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, data)
    }

    func testShouldReadDataFromDataProducerWithMultipleSmallChunks() {
        let chunks = NSData.chunksOfData(count: 5, ofLength: smallChunkLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithMultipleBigChunks() {
        let chunks = NSData.chunksOfData(count: 5, ofLength: bigChunkLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithChunksOfReadSize() {
        let chunks = NSData.chunksOfData(count: 5, ofLength: readLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithChunksOfVariousSizes() {
        let smallChunks = NSData.chunksOfData(count: 2, ofLength: smallChunkLength)
        let readLengthChunks = NSData.chunksOfData(count: 2, ofLength: readLength)
        let bigChunks = NSData.chunksOfData(count: 2, ofLength: bigChunkLength)
        let chunks = smallChunks + readLengthChunks + bigChunks
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }
}

private func readAllData(from bytesGenerator: BytesGenerator) -> NSData {
    let mutableData = NSMutableData()
    var buffer = [UInt8](count: readLength, repeatedValue: 0)
    while let readLength = try? bytesGenerator.read(&buffer, maxLength: readLength)
        where readLength > 0
    {
        mutableData.appendBytes(&buffer, length: readLength)
    }
    return mutableData
}

private func appendAllData(from chunks: [NSData]) -> NSData {
    return chunks.reduce(NSMutableData()) { (accumulator, data) -> NSMutableData in
        accumulator.appendData(data)
        return accumulator
    }
}
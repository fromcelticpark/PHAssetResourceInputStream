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

        XCTAssertEqual(data, Data())
    }

    func testShouldReadDataFromDataProducerWithSmallChunk() {
        let data = Data.emptyDataOfLength(smallChunkLength)
        let dataGenerator = MockDataGenerator(chunks: [data])
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, data)
    }

    func testShouldReadDataFromDataProducerWithBigChunk() {
        let data = Data.emptyDataOfLength(bigChunkLength)
        let dataGenerator = MockDataGenerator(chunks: [data])
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, data)
    }

    func testShouldReadDataFromDataProducerWithMultipleSmallChunks() {
        let chunks = Data.chunksOfData(count: 5, ofLength: smallChunkLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithMultipleBigChunks() {
        let chunks = Data.chunksOfData(count: 5, ofLength: bigChunkLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithChunksOfReadSize() {
        let chunks = Data.chunksOfData(count: 5, ofLength: readLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithChunksOfVariousSizes() {
        let smallChunks = Data.chunksOfData(count: 2, ofLength: smallChunkLength)
        let readLengthChunks = Data.chunksOfData(count: 2, ofLength: readLength)
        let bigChunks = Data.chunksOfData(count: 2, ofLength: bigChunkLength)
        let chunks = smallChunks + readLengthChunks + bigChunks
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }
}

private func readAllData(from bytesGenerator: BytesGenerator) -> Data {
    let mutableData = NSMutableData()
    var buffer = [UInt8](repeating: 0, count: readLength)
    while let readLength = try? bytesGenerator.read(&buffer, maxLength: readLength)
        , readLength > 0
    {
        mutableData.append(&buffer, length: readLength)
    }
    return mutableData
}

private func appendAllData(from chunks: [Data]) -> Data {
    return chunks.reduce(NSMutableData()) { (accumulator, data) -> NSMutableData in
        accumulator.append(data)
        return accumulator
    } as Data
}

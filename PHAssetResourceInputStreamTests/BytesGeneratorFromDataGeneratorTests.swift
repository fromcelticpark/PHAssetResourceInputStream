//
//  BytesGeneratorFromDataGeneratorTests.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import XCTest
import PHAssetResourceInputStream

private let readLength = 1024
private let smallChunkLength = 500
private let bigChunkLength = 2000

class BytesGeneratorFromDataGeneratorTests: XCTestCase {
    func testShouldReadNoDataFromEmptyDataProducer() {
        let dataGenerator = MockDataGenerator.empty()
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)

        let data = readAllData(from: bytesGenerator)

        XCTAssertEqual(data, Data())
    }

    func testShouldReadDataFromDataProducerWithSmallChunk() {
        let data = Data.emptyDataOfLength(smallChunkLength)
        let dataGenerator = MockDataGenerator(chunks: [data])
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, data)
    }

    func testShouldReadDataFromDataProducerWithBigChunk() {
        let data = Data.emptyDataOfLength(bigChunkLength)
        let dataGenerator = MockDataGenerator(chunks: [data])
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, data)
    }

    func testShouldReadDataFromDataProducerWithMultipleSmallChunks() {
        let chunks = Data.chunksOfData(count: 5, ofLength: smallChunkLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithMultipleBigChunks() {
        let chunks = Data.chunksOfData(count: 5, ofLength: bigChunkLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }

    func testShouldReadDataFromDataProducerWithChunksOfReadSize() {
        let chunks = Data.chunksOfData(count: 5, ofLength: readLength)
        let allData = appendAllData(from: chunks)

        let dataGenerator = MockDataGenerator(chunks: chunks)
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)

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
        let bytesGenerator = BytesGeneratorFromDataGenerator(dataGenerator: dataGenerator)

        let dataThatWasRead = readAllData(from: bytesGenerator)

        XCTAssertEqual(dataThatWasRead, allData)
    }
}

private func readAllData(from bytesGenerator: BytesGenerator) -> Data {
    var data = Data()
    var buffer = [UInt8](repeating: 0, count: readLength)
    while let dataReadLength = try? bytesGenerator.read(from: &buffer, maxLength: readLength)
        , dataReadLength > 0
    {
        data.append(&buffer, count: dataReadLength)
    }
    return data
}

private func appendAllData(from chunks: [Data]) -> Data {
    return chunks.reduce(NSMutableData()) { (accumulator, data) -> NSMutableData in
        accumulator.append(data)
        return accumulator
    } as Data
}

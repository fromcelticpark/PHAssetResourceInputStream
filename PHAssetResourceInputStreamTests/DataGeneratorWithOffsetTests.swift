//
//  DataGeneratorWithOffsetTests.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import XCTest
import PHAssetResourceInputStream

class DataGeneratorWithOffsetTests: XCTestCase {
    let chunks = Data.chunksOfEmptyData(count: 5, length: 10)

    func testShouldReadFromTheBeginning() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 0)

        let result = dataGeneratorWithOffset.allValues()

        XCTAssertEqual(result, chunks)
    }

    func testShouldReadFromOffsetInTheFirstChunk() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 5)

        let result = dataGeneratorWithOffset.allValues()
        let expected = [Data.emptyDataOfLength(5)] + Data.chunksOfEmptyData(count: 4, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldReadFromOffsetInTheMiddleChunk() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 25)

        let result = dataGeneratorWithOffset.allValues()
        let expected = [Data.emptyDataOfLength(5)] + Data.chunksOfEmptyData(count: 2, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldReadFromOffsetInTheEndOfChunk() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 9)

        let result = dataGeneratorWithOffset.allValues()
        let expected = [Data.emptyDataOfLength(1)] + Data.chunksOfEmptyData(count: 4, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldReadFromOffsetInTheBeginningOfChunk() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 10)

        let result = dataGeneratorWithOffset.allValues()
        let expected = Data.chunksOfEmptyData(count: 4, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldNotReadFromOffsetThatIsEqualToWholeDataLength() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 50)

        let result = dataGeneratorWithOffset.allValues()
        let expected = [Data]()

        XCTAssertEqual(result, expected)
    }

    func testShouldNotReadFromOffsetThatOverWholeDataLength() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 999)

        let result = dataGeneratorWithOffset.allValues()
        let expected = [Data]()
        
        XCTAssertEqual(result, expected)
    }
    
}

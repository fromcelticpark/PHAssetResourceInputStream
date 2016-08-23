//
//  DataGeneratorWithOffsetTests.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import XCTest
import PHAssetResourceInputStream

class DataGeneratorWithOffsetTests: XCTestCase {
    let chunks = NSData.chunksOfEmptyData(count: 5, length: 10)

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
        let expected = [NSData.emptyDataOfLength(5)] + NSData.chunksOfEmptyData(count: 4, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldReadFromOffsetInTheMiddleChunk() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 25)

        let result = dataGeneratorWithOffset.allValues()
        let expected = [NSData.emptyDataOfLength(5)] + NSData.chunksOfEmptyData(count: 2, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldReadFromOffsetInTheEndOfChunk() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 9)

        let result = dataGeneratorWithOffset.allValues()
        let expected = [NSData.emptyDataOfLength(1)] + NSData.chunksOfEmptyData(count: 4, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldReadFromOffsetInTheBeginningOfChunk() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 10)

        let result = dataGeneratorWithOffset.allValues()
        let expected = NSData.chunksOfEmptyData(count: 4, length: 10)

        XCTAssertEqual(result, expected)
    }

    func testShouldNotReadFromOffsetThatIsEqualToWholeDataLength() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 50)

        let result = dataGeneratorWithOffset.allValues()
        let expected = []

        XCTAssertEqual(result, expected)
    }

    func testShouldNotReadFromOffsetThatOverWholeDataLength() {
        let mockDataGenerator = MockDataGenerator(chunks: chunks)
        let dataGeneratorWithOffset = DataGeneratorWithOffset(dataGenerator: mockDataGenerator, offset: 999)

        let result = dataGeneratorWithOffset.allValues()
        let expected = []
        
        XCTAssertEqual(result, expected)
    }
    
}
//
//  DataGenerator.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2016 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public protocol DataGenerator {
    func nextChunk() throws -> NSData?
}
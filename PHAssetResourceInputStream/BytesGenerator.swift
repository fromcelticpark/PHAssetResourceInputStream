//
//  BytesGenerator.swift
//  PHAssetResourceInputStream
//
//  Created by Aleksandr Dvornikov on 23/08/16.
//  Copyright © 2017 Aleksandr Dvornikov. All rights reserved.
//

import Foundation

public protocol BytesGenerator {
    var readOffset: UInt64 { get }
    func read(from buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) throws -> Int
}
